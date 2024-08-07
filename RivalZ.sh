#!/bin/bash

# 安装依赖和 RivalZ 函数
function install_all() {
    # 更新包列表和升级系统
    echo "更新包列表和升级系统..."
    sudo apt update && sudo apt upgrade -y

    # 安装 Git
    echo "安装 Git..."
    sudo apt install -y git

    # 安装 curl
    echo "安装 curl..."
    sudo apt install -y curl

    # 安装 screen
    echo "安装 screen..."
    sudo apt install -y screen

    # 安装 npm
    echo "安装 npm..."
    sudo apt install -y npm

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

    if npm --version &>/dev/null; then
        echo "npm 安装成功!"
    else
        echo "npm 安装失败，请检查错误信息。"
    fi

    # 安装 Rivalz
    echo "安装 Rivalz..."
    npm i -g rivalz-node-cli

    echo "依赖和 RivalZ 节点安装完成。"
}

# 打开新屏幕
function start_rivalz() {
    echo "打开新屏幕..."
    screen -S rivalz
    echo "新屏幕已打开。"
    read -p "按任意键返回主菜单..."
}

# 删除 Rivalz
function remove_rivalz() {
    echo "删除 Rivalz..."
    if [ -f /usr/bin/rivalz ]; then
        echo "找到 Rivalz，正在删除..."
        sudo rm /usr/bin/rivalz
        echo "Rivalz 已删除。"
    else
        echo "Rivalz 不存在，无法删除。"
    fi
    read -p "按任意键返回主菜单..."
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
        echo "2) 打开新屏幕"
        echo "3) 删除 Rivalz"
        echo "0) 退出"
        read -p "输入选项 (0-3): " choice

        case $choice in
            1)
                install_all
                ;;
            2)
                start_rivalz
                ;;
            3)
                remove_rivalz
                ;;
            0)
                echo "退出脚本..."
                exit 0
                ;;
            *)
                echo "无效的选项，请重新输入。"
                ;;
        esac

        # 添加提示用户按任意键返回主菜单
        read -p "按任意键返回主菜单..."
    done
}

# 执行主菜单函数
main_menu
