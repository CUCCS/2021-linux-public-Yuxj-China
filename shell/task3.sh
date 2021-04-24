#!/usr/bin/env bash

#帮助文档
function help {
    echo "Help Document"
    echo "-n                 统计访问来源主机TOP 100和分别对应出现的总次数"
    echo "-i                 统计访问来源主机TOP 100 IP和分别对应出现的总次数"
    echo "-u                 统计最频繁被访问的URL TOP 100"
    echo "-s                 统计不同响应状态码的出现次数和对应百分比"
    echo "-x                 分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数"
    echo "-o  URL            给定URL输出TOP 100访问来源主机"
    echo "-h                 帮助文档"
}

# 统计访问来源主机TOP 100和分别对应出现的总次数
function host-top100 {
    printf "%40s\t%s\n" "host-top100" "Number"
    awk -F "\t" '
    NR>1 {host[$1]++;}
    END { 
            for(i in host) {
                printf("%40s\t%d\n",i,host[i]);
            }
        }' web_log.tsv | sort -g -k 2 -r | head -100
}

# 统计访问来源主机TOP 100 IP和分别对应出现的总次数
function top100-ip {
    printf "%55s\t%s\n" "top100-ip" "Number"
    awk -F "\t" '
    NR>1 {
        if(match($1, /^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/))
        ip[$1]++;
    }
    END {
            for(i in ip) {
                printf("%20s\t%d\n",i,ip[i]);
            }
        } ' web_log.tsv | sort -g -k 2 -r | head -100
}

# 统计最频繁被访问的URL TOP 100
function top100-URL {
    printf "%55s\t%s\n" "top100-URL" "Number"
    awk -F "\t" '
    NR>1 {url[$5]++;}
    END {
            for(i in url){
                printf("%55s\t%d\n",i,url[i]);
            }
        } ' web_log.tsv | sort -g -k 2 -r | head -100
}

# 统计不同响应状态码的出现次数和对应百分比"
function state-code {
    awk -F "\t" '
    BEGIN {printf("Code\tNumber\tPercentage\n");}
    NR>1 {code[$6]++;}
    END {
            for(i in code) {
                printf("%d\t%d\t%f%%\n",i,code[i],100.0*code[i]/(NR-1));
            }
        } ' web_log.tsv
}

# 分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
function top10-4xxcode {
    printf "%55s\t%s\n" "code=403 URL" "Number"
    awk -F "\t" '
    NR>1{
            if($6=="403")
            code[$5]++;
        }
    END {
            for(i in code) {
                printf("%55s\t%d\n",i,code[i]);
            }
        } ' web_log.tsv | sort -g -k 2 -r | head -10

    printf "%55s\t%s\n" "code==404 URL" "Number"
    awk -F "\t" '
    NR>1{
            if($6=="404")
            code[$5]++;
        }
    END {
            for(i in code) {
                printf("%55s\t%d\n",i,code[i]);
            } 
        } ' web_log.tsv | sort -g -k 2 -r | head -10
}

# 给定URL输出TOP 100访问来源主机
function host-top100-URL {
    printf "%40s\t%s\n" "host-top100" "Number"
    awk -F "\t" '
    NR>1 {
            if("'"$1"'"==$5) {
                host[$1]++;
            }
        }
    END {
            for(i in host) {
                printf("%40s\t%d\n",i,host[i]);
            }
        } ' web_log.tsv | sort -g -k 2 -r | head -100
}
while [ "$1" != "" ];do
    case "$1" in
        "-n")
        host-top100
        exit 0
        ;;
        "-i")
        top100-ip
        exit 0
        ;;
        "-u")
        top100-URL
        exit 0
        ;;
        "-s")
        state-code
        exit 0
        ;;
        "-x")
        top10-4xxcode
        exit 0
        ;;
        "-o")
        host-top100-URL "$2"
        exit 0
        ;;
        "-h")
        help
        exit 0
        ;;
    esac
done