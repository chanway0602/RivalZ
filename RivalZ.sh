#!/bin/bash

# 安装依赖和 RivalZ 函数
function install_all() {
    # 更新包列表和升级系统
    echo "更新包列表和升级系统..."
    sudo apt update && sudo apt upgrade -y

    # 删除现有的 Node.js 和 npm 安装
    echo "删除现有的 Node.js 和 npm 安装..."
    sudo apt-get remove --purge -y nodejs npm
    sudo apt-get autoremove -y
    sudo apt-get autoclean -y

    # 尝试修复任何破损的包
    echo "修复破损包..."
    sudo apt --fix-broken install -y

    # 清理任何残留的包信息
    echo "清理包缓存..."
    sudo apt clean

    # 安装 Git、curl 和 screen
    for pkg in git curl screen; do
        echo "安装 $pkg..."
        sudo apt install -y $pkg
        if command -v $pkg &>/dev/null; then
            echo "$pkg 安装成功!"
        else
            echo "$pkg 安装失败，请检查错误信息。"
            exit 1
        fi
    done

    # 安装 Node.js 和 npm
    echo "安装 Node.js 和 npm..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt install -y nodejs

    # 验证 Node.js 和 npm 是否安装成功
    if command -v node &>/dev/null && command -v npm &>/dev/null; then
        echo "Node.js 和 npm 安装成功!"
    else
        echo "Node.js 或 npm 安装失败，请检查错误信息。"
        exit 1
    fi

    # 安装 Rivalz
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

    echo "依赖和 Rivalz 节点安装完成。"

    # 创建 screen 会话并运行 rivalz
    echo "创建 screen 会话并运行 Rivalz..."
    screen -dmS rivalz bash -c "rivalz run; exec bash"

    # 提示用户进入 screen 会话并监控进程
    echo "Rivalz 正在 screen 会话中运行。"
    echo "请使用 'screen -r rivalz' 命令进入 screen 会话，完成相关设置后，按任意键返回主菜单..."
    read -n 1 -s
}

# 删除 Rivalz
function remove_rivalz() {
    echo "删除 Rivalz..."
    
    # 检查并删除 rivalz 命令
    if command -v rivalz &>/dev/null; then
        echo "找到 Rivalz，正在删除..."
        sudo rm $(which rivalz)
        echo "Rivalz 已删除。"
    else
        echo "Rivalz 不存在，无法删除。"
    fi

    # 删除 /root/.rivalz 文件夹
    if [ -d /root/.rivalz ]; then
        echo "找到 /root/.rivalz 文件夹，正在删除..."
        sudo rm -rf /root/.rivalz
        echo "/root/.rivalz 文件夹已删除。"
    else
        echo "/root/.rivalz 文件夹不存在。"
    fi

    # 删除 /root/.nvm/versions/node/v20.0.0/bin/rivalz 文件
    if [ -f /root/.nvm/versions/node/v20.0.0/bin/rivalz ]; then
        echo "找到 /root/.nvm/versions/node/v20.0.0/bin/rivalz 文件，正在删除..."
        sudo rm /root/.nvm/versions/node/v20.0.0/bin/rivalz
        echo "/root/.nvm/versions/node/v20.0.0/bin/rivalz 文件已删除。"
    else
        echo "/root/.nvm/versions/node/v20.0.0/bin/rivalz 文件不存在。"
    fi

    # 删除 /root/.npm/rivalz-node-cli 目录
    if [ -d /root/.npm/rivalz-node-cli ]; then
        echo "找到 /root/.npm/rivalz-node-cli 目录，正在删除..."
        sudo rm -rf /root/.npm/rivalz-node-cli
        echo "/root/.npm/rivalz-node-cli 目录已删除。"
    else
        echo "/root/.npm/rivalz-node-cli 目录不存在。"
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
        echo "2) 删除 Rivalz"
        echo "3) 错误修复重新运行（请打开新的屏幕进行）"
        echo "0) 退出"
        read -p "输入选项 (0-3): " choice

        case $choice in
            1)
                install_all
                ;;
            2)
                remove_rivalz
                ;;
            3)
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

        # 添加提示用户按任意键返回主菜单
        read -p "操作完成，按任意键返回主菜单..."
    done
}

# 执行主菜单函数
main_menu
