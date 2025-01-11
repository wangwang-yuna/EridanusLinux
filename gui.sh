#!/bin/bash

# 检查 napcat 是否运行
is_napcat_running() {
    if pgrep -f "napcat" > /dev/null; then
        return 0  # napcat 正在运行
    else
        return 1  # napcat 未运行
    fi
}

# 使用 dialog 创建菜单
dialog --title "Eridanus" --menu "请选择一个操作：" 12 40 2 \
    1 "启动Eridanus" \
    2 "启动napcat" \
    2> /tmp/menu_choice

# 检查用户是否选择了选项
if [ $? -eq 0 ]; then
    # 读取用户的选择
    choice=$(cat /tmp/menu_choice)

    # 根据用户选择执行相应的命令
    case $choice in
        1)
            # 检查 napcat 是否在运行
            if ! is_napcat_running; then
                dialog --msgbox "napcat 没有运行，先启动 napcat。" 6 40
                # 启动 napcat
                screen -dmS napcat bash -c "xvfb-run -a qq --no-sandbox"
                sleep 2  # 等待 napcat 启动
            fi
            echo "正在启动 Eridanus..."
            python3 Eridanus/main.py
            ;;
        2)
            echo "正在启动 napcat..."
            screen -dmS napcat bash -c "xvfb-run -a qq --no-sandbox"
            sleep 2  # 等待 napcat 启动
            dialog --msgbox "napcat 启动成功！\n访问链接：\nhttp://0.0.0.0:6099/webui?token=3eityfay1fv" 10 50
            ;;
        *)
            echo "无效的选择"
            ;;
    esac
else
    echo "操作已取消"
fi

# 清理临时文件
rm -f /tmp/menu_choice
