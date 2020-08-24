#!/bin/bash
# -i: local ip
# -m: 处理完多少次呼叫后停止请求,也就是最多发送多少个请求, 如果要持续发送请求，可以不加 -m 参数
# -trace_msg: 产生调试日志
# -trace_err: 产生错误日志
# 10.0.0.47:7080: 服务器地址
# -l: 同时保持最大的呼叫量(比如注册数)
# -r 1000 -rp 2000: 设置发送请求的频率, 这里表示：2000ms 发送 1000个请求, 也可以写成 -r 1000 -rp 2s
# -aa: Info, update 等消息自动回复 200Ok

sipp -sf branchc.xml -inf user.csv -i 192.168.50.132 -l 1000 -r 1000 -rp 1000 -m 1000 -trace_msg 10.0.0.47:7080 -aa -trace_err
