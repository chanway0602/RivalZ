#!/bin/bash

# 安装依赖和 RivalZ 函数
function install_all() {
    echo "更新包列表和升级系统..."
    sudo apt update && sudo apt upgrade -y

    for pkg in git curl screen npm; do
        echo "安装 $pkg..."
        sudo apt install -y $pkg
        if command -v $pkg &>/dev/null; then
            echo "$pkg 安装成功!"
        else
            echo "$pkg 安装失败，请检查错误信息。"
            exit 1
        fi
    done

    echo "安装 Rivalz..."
    if npm list -g rivalz-node-cli &>/dev/null; then
        echo "Rivalz 已经安装。"
    else
        npm i -g rivalz-node-cli
        if npm list -g rivalz-node-cli &>/dev/null; then
            echo "Rivalz 安装成功!"
        else
            echo "Rivalz 安装失败，请检查错误信息。"
            exit 1
        fi
    fi

    echo "依赖和 RivalZ 节点安装完成。"
}

# 删除 Rivalz
function remove_rivalz() {
    echo "删除 Rivalz..."

    if command -v rivalz &>/dev/null; then
        echo "找到 Rivalz，正在删除..."
        sudo rm $(which rivalz)
        echo "Rivalz 已删除。"
    else
        echo "Rivalz 不存在，无法删除。"
    fi

    if [ -d /root/.rivalz ]; then
        echo "找到 /root/.rivalz 文件夹，正在删除..."
        sudo rm -rf /root/.rivalz
        echo "/root/.rivalz 文件夹已删除。"
    else
        echo "/root/.rivalz 文件夹不存在。"
    fi

    if [ -f /root/.nvm/versions/node/v20.0.0/bin/rivalz ]; then
        echo "找到 /root/.nvm/versions/node/v20.0.0/bin/rivalz 文件，正在删除..."
        sudo rm /root/.nvm/versions/node/v20.0.0/bin/rivalz
        echo "/root/.nvm/versions/node/v20.0.0/bin/rivalz 文件已删除。"
    else
        echo "/root/.nvm/versions/node/v20.0.0/bin/rivalz 文件不存在。"
    fi

    if [ -d /root/.npm/rivalz-node-cli ]; then
        echo "找到 /root/.npm/rivalz-node-cli 目录，正在删除..."
        sudo rm -rf /root/.npm/rivalz-node-cli
        echo "/root/.npm/rivalz-node-cli 目录已删除。"
    else
        echo "/root/.npm/rivalz-node-cli 目录不存在。"
    fi
}

# 更新版本
function update_version() {
    echo "更新 Rivalz 版本..."
    if rivalz update-version; then
        rivalz run
        echo "版本更新完成。"
    else
        echo "版本更新失败，请检查错误信息。"
    fi
}

# 错误修复重新运行
function fix_and_restart() {
    echo "执行硬件配置更改..."
    rivalz change-hardware-config
    echo "请重新配置硬盘容量，完成后按任意键继续..."
    read -n 1 -s

    echo "执行钱包配置更改..."
    rivalz change-wallet
    echo "请重新配置钱包地址，完成后按任意键继续..."
    read -n 1 -s

    echo "运行 Rivalz..."
    rivalz run
    echo "操作完成。"
}

# 在新的 screen 会话中执行 update-version 和 run
function screen_rivalz() {
    echo "创建并进入新的 screen 会话..."
    screen -S rivalz -dm

    echo "在 screen 会话中执行 Rivalz 命令..."
    screen -S rivalz -p 0 -X stuff "rivalz update-version\n"
    screen -S rivalz -p 0 -X stuff "rivalz run\n"

    echo "请手动在 screen 会话中完成配置。完成后按任意键返回主菜单..."
    read -n 1 -s
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
        echo "2) 新建Rivalz屏幕"
        echo "3) 删除 Rivalz"
        echo "4) 更新版本"
        echo "5) 错误修复重新运行（请打开新的屏幕进行）"
        echo "0) 退出"
        read -p "输入选项 (0-5): " choice

        case $choice in
            1)
                install_all
                ;;
            2)
                screen_rivalz
                ;;
            3)
                remove_rivalz
                ;;
            4)
                update_version
                ;;
            5)
                fix_and_restart
                ;;
            0)
                echo "退出脚本..."
                exit 0
                ;;
            *)
                echo "无效的选项，请重新输入。"
                ;;
        esac

        read -p "操作完成，按任意键返回主菜单..."
    done
}

# 执行主菜单函数
main_menu
