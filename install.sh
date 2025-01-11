#!/bin/bash

echo "sudo将持续安装过程"
# 更新软件包源
sudo apt-get update
# 安装软件包
sudo apt-get install -y git python3 python3-pip python3.11-venv unzip dialog curl wget screen

# 用户选择列表倒计时10秒
echo "选择git clone源"

link1=https://githubfast.com/avilliai/Eridanus.git
link2=https://gitclone.com/github.com/avilliai/Eridanus.git
link3=https://github.com/avilliai/Eridanus.git
default=https://ghp.ci/https://github.com/avilliai/Eridanus.git

# 使用 select 进行选择
select link in "$link1" "$link2" "$link3" "$default"; do
    case $REPLY in
        1) git clone "$link1"; break ;;
        2) git clone "$link2"; break ;;
        3) git clone "$link3"; break ;;
        4) git clone "$default"; break ;;
        *) echo "无效的选择，使用默认 git 源"; git clone "$default"; break ;;
    esac
done

# 创建虚拟环境
echo "创建虚拟环境"
python3 -m venv .base

# 激活虚拟环境
echo "激活虚拟环境"
source .base/bin/activate

# 检查虚拟环境是否激活成功
if [ -z "$VIRTUAL_ENV" ]; then
    echo "虚拟环境激活失败，请检查！"
    exit 1
else
    echo "虚拟环境已激活：$VIRTUAL_ENV"
fi

# 安装 napcat
echo "安装 napcat"

# 下载脚本并检查内容
curl -o napcat.sh https://nclatest.znin.net/NapNeko/NapCat-Installer/main/script/install.sh
if [[ -f "napcat.sh" ]]; then
    echo "下载成功，开始安装..."
    dialog --msgbox "是否安装 napcat?" 7 60
    # 无条件执行安装
    sudo bash napcat.sh
else
    echo "下载失败，请检查网络连接！"
    exit 1
fi

# 安装 pip 依赖包
if [ -f requirements.txt ]; then
    echo "安装 pip 依赖包"
    cd Eridanus
    pip3 install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
else
    echo "requirements.txt 文件不存在!"
    echo "请检查文件路径是否正确!"
fi

echo "请不要忘记激活虚拟环境！"
echo "source .base/bin/activate"

echo "=================================================================================================================================="

echo "本脚本只是为了方便学习 Eridanus，如果用于商业用途，请自行承担风险！"
printf "="%.0s {1..50}
echo ""
echo "作者：wangwang-yuna"
echo "有问题加QQ群：913122269"
echo "项目地址：https://github.com/wangwang-yuna/Eridanuslinux"
echo "Eridanus项目地址：https://github.com/avilliai/Eridanus"
echo "本项目采用 AGPL-3.0 协议开源，请遵守协议！"

echo "==================================================================================================================================="
