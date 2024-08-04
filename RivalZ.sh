#!/bin/bash

# 安装 Git 和 curl 函数
function install_dependencies() {
    # 更新包列表
    echo "更新包列表..."
    sudo apt update

    # 安装 Git
    echo "安装 Git..."
    sudo apt install -y git

    # 安装 curl
    echo "安装 curl..."
    sudo apt install -y curl

    # 安装 screen
    echo "安装 screen..."
    sudo apt install -y screen

    # 检查 Git、curl 和 screen 安装情况
    if git --version &>/dev/null; then
        echo "Git 安装成功!"
    else
        echo "Git 安装失败，请检查错误信息。"
    fi

    if curl --version &>/dev/null; then
        echo "curl 安装成功!"
    else
        echo "curl 安装失败，请检查错误信息。"
    fi

    if screen --version &>/dev/null; then
        echo "screen 安装成功!"
    else
        echo "screen 安装失败，请检查错误信息。"
    fi
}

# 安装 Rivalz 函数
function install_rivalz() {
    # 安装 Rivalz
    echo "安装 Rivalz..."
    npm i -g rivalz-node-cli

    # 启动 Rivalz 并打开新屏幕
    echo "打开新屏幕并执行 Rivalz 命令..."
    screen -S rivalz -dm bash -c "rivalz update-version; rivalz run"

    echo "脚本执行完成。"
}

# 主菜单函数
function main_menu() {
    while true; do
        clear
        echo "脚本由大赌社区哈哈哈哈编写，推特 @ferdie_jhovie，免费开源，请勿相信收费"
        echo "================================================================"
        echo "节点社区 Telegram 群组: https://t.me/niuwuriji"
        echo "节点社区 Telegram 频道: https://t.me/niuwuriji"
        echo "节点社区 Discord 社群: https://discord.gg/GbMV5EcNWF"
        echo "退出脚本，请按键盘 ctrl + C 退出即可"
        echo "请选择要执行的操作:"
        echo "1) 安装RivalZ节点"
        echo "0) 退出"
        read -p "输入选项 (0-1): " choice

        case $choice in
            1)
                install_dependencies
                install_rivalz
                ;;
            0)
                echo "退出脚本..."
                exit 0
                ;;
            *)
                echo "无效的选项"
                ;;
        esac
    done
}

# 执行主菜单函数
main_menu
