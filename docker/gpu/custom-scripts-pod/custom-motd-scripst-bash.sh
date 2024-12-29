#!/bin/bash

print_system_info() {
    echo "当前时间: $(date)"
    echo "系统信息:"
    echo "操作系统: $(uname -s)"
    echo "内核版本: $(uname -r)"
    echo "已登录用户: $(who | wc -l)"
    echo "内存使用: $(free -h | awk '/^Mem/ {print $3 "/" $2}')"
    echo "CPU 负载: $(uptime | awk -F 'load average:' '{print $2}')"
}

print_logo() {
    # 定义 "HQ" ASCII 艺术
    hq=(
        "         _       _    _        "
        "        / /\    / /\ /\ \      "
        "       / / /   / / //  \ \     "
        "      / /_/   / / // /\ \ \    "
        "     / /\ \__/ / // / /\ \ \   "
        "    / /\ \___\/ // / /  \ \_\  "
        "   / / /\/___/ // / / _ / / /  "
        "  / / /   / / // / / /\ \/ /   "
        " / / /   / / // / /__\ \ \/    "
        "/ / /   / / // / /____\ \ \    "
        "\/_/    \/_/ \/________\_\/    "
    )
    for line in "${hq[@]}"; do
        echo "$line"
    done
}


# 打印表格的函数
print_table() {
    local -a headers=("${!1}")
    local -a rows=("${!2}")

    # 计算每列的最大长度
    local column_lengths=()
    for i in "${!headers[@]}"; do
        column_lengths[i]=${#headers[i]}
    done

    # 遍历数据行，计算每列的最大长度
    for row in "${rows[@]}"; do
        IFS=$'\t' read -r -a columns <<< "$row"
        for ((i = 0; i < ${#columns[@]}; i++)); do
            if (( ${#columns[i]} > column_lengths[i] )); then
                column_lengths[i]=${#columns[i]}
            fi
        done
    done

    # 计算总宽度
    local total_width=1  # 初始化为1，用于左边的分割符
    for ((i = 0; i < ${#column_lengths[@]}; i++)); do
        if ((i < ${#column_lengths[@]} - 1)); then
            total_width=$((total_width + column_lengths[i] + 3))  # 每列增加3（1个空格 + 2个分割符）
        else
            total_width=$((total_width + column_lengths[i] + 2))  # 最后一列只增加2（1个空格 + 1个分割符）
        fi
    done

    # 打印顶部边框
    printf "+%s+\n" "$(printf "%-${total_width}s" "" | tr ' ' '=')"

    # 打印表头
    printf "| "
    for ((i = 0; i < ${#headers[@]}; i++)); do
        if ((i < ${#headers[@]} - 1)); then
            printf "%-${column_lengths[i]}s | " "${headers[i]}"
        else
            printf "%-${column_lengths[i]}s " "${headers[i]}"
        fi
    done
    printf "|\n"

    # 打印表头下方的分割线
    printf "+%s+\n" "$(printf "%-${total_width}s" "" | tr ' ' '=')"

    # 打印数据行
    # 打印数据行
    for row in "${rows[@]}"; do
        IFS=$'\t' read -r -a columns <<< "$row"
        printf "| "
        for ((i = 0; i < ${#columns[@]}; i++)); do
            if ((i < ${#columns[@]} - 1)); then
                printf "%-${column_lengths[i]}s | " "${columns[i]}"
            else
                # 最后一列不加分割符，但确保对齐
                printf "%-${column_lengths[i]}s " "${columns[i]}"
            fi
        done
        printf "\n"
    done

    # 打印底部边框
    printf "+%s+\n" "$(printf "%-${total_width}s" "" | tr ' ' '=')"
}

# 定义打印说明的函数
print_instructions() {
    echo "1. 依赖库下载加速：您可以通过工具面板-切换下载源更换国内Pip/Conda/Apt源，提升库类下载速度。"
    echo "2. 开发环境自动保存：您可以在关机时保存开发环境以便下次使用。保存文件大小限 506 以内，否则可能导致系统性能降低甚至保存失败。"
    # 定义表格的标题、表头和数据行
    echo "目录说明:"
    headers=("目录" "名称" "说明")
    rows=(
        "/	系统盘	可存放依赖包、代码等小文件，随镜像一起保存。"
        "/root/private_data	用户个人数据('/public/home/scmwt8e9hr)	当前用户下存储的文件，不受实例开关机和镜像保存的影响。"
        "/root/group_data	平台团队数据('/public/share/acdev9gcs1)	团队共享资源，不受实例开关机和镜像保存的影响。"
        "/root/public_data	平台共享数据('/public/SothisAI/sharingCenter)	平台内用户共享的深度学习资产，仅支持读取。"
    )

    # 调用 print_table 函数打印表格
    print_table headers[@] rows[@]
}



# 打印欢迎信息
echo "欢迎登录到 $(hostname) 服务器"
print_logo
print_instructions
print_system_info