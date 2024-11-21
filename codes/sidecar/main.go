package main

import (
	"context"
	"fmt"
	"log"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"

	"k8s-prom/prom"
	"k8s-prom/config"
)

// createKubernetesClient 创建 Kubernetes 客户端
func getClient(kubeconfig string) (*kubernetes.Clientset, error) {

	// 创建 Kubernetes 客户端配置
	config, err := clientcmd.BuildConfigFromFlags("", kubeconfig)
	if err != nil {
		log.Fatalf("Error building kubeconfig: %s", err.Error())
	}

	// 创建 Kubernetes 客户端
	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		log.Fatalf("Error creating clientset: %s", err.Error())
	}

	return clientset, nil
}

// getNodesWithAnnotation 获取带有特定注解的节点
func getNodesWithAnnotation(clientset *kubernetes.Clientset, annotationKey string) ([]string, error) {
	// 获取所有节点
	nodes, err := clientset.CoreV1().Nodes().List(context.TODO(), metav1.ListOptions{})
	if err != nil {
		return nil, fmt.Errorf("error listing nodes: %s", err.Error())
	}

	// 查找带有特定注解的节点
	var annotatedNodes []string
	for _, node := range nodes.Items {
		if node.Annotations[annotationKey] != "" {
			annotatedNodes = append(annotatedNodes, node.Name)
		}
	}

	return annotatedNodes, nil
}


// queryCPUUsage 查询 CPU 使用率
func queryCPUUsage(client *prom.Client) (string, error) {
	// 查询 CPU 使用率
	query := "100 - (avg by (instance) (irate(node_cpu_seconds_total{mode='idle'}[5m])) * 100)"
	result, err := client.Query(context.Background(), query)
	if err != nil {
		return "", fmt.Errorf("error querying Prometheus: %v", err)
	}

	// 格式化查询结果
	formattedResult := formatQueryResult(result)
	return formattedResult, nil
}

// formatQueryResult 格式化查询结果
func formatQueryResult(result interface{}) string {
	// 这里假设 result 是一个 model.Value 类型
	// 你可以根据实际的 result 类型进行格式化
	return fmt.Sprintf("Query result: %v", result)
}

func main() {
	// 加载 kubeconfig 文件
	// 加载配置文件
	cfg, err := config.LoadConfig("config/config.yaml")
	if err != nil {
		log.Fatalf("Error loading config: %v", err)
	}
	kubeconfig := cfg.Kubeconfig.Path

	// 创建 Kubernetes 客户端
	clientset, err := getClient(kubeconfig)
	if err != nil {
		log.Fatalf("Error creating Kubernetes client: %s", err.Error())
	}

	// 查找带有特定注解的节点
	annotationKey := "hami.io/node-handshake"
	annotatedNodes, err := getNodesWithAnnotation(clientset, annotationKey)
	if err != nil {
		log.Fatalf("Error getting nodes with annotation: %s", err.Error())
	}

	// 输出带有特定注解的节点
	for _, node := range annotatedNodes {
		fmt.Printf("Node %s has annotation %s\n", node, annotationKey)
	}

	// 创建 Prometheus 客户端
	prometheusServerUrl := cfg.Prometheus.Address
	client, err := prom.NewClient(prometheusServerUrl, cfg.Prometheus.Timeout, "")
	if err != nil {
		log.Fatalf("Error creating Prometheus client: %v", err)
	}

	// 查询 CPU 使用率
	cpuUsage, err := queryCPUUsage(client)
	if err != nil {
		log.Fatalf("Error querying CPU usage: %v", err)
	}

	// 打印查询结果
	fmt.Println(cpuUsage)
}
