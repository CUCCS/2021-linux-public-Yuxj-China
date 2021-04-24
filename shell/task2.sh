#!/usr/bin/env bash

#帮助文档
function help {
    echo "Help Document"
    echo "-a                  统计不同年龄区间范围(20岁以下、[20-30]、30岁以上)的球员数量、百分比"
    echo "-l                  统计不同场上位置的球员数量、百分比"
    echo "-n                  名字最长的球员是谁？名字最短的球员是谁？"
    echo "-m                  年龄最大的球员是谁？年龄最小的球员是谁"
    echo "-h                  帮助文档"
}

#统计不同年龄区间范围(20岁以下、[20-30]、30岁以上)的球员数量、百分比
function count_age {
    #指定输入文件折分隔符
    awk -F "\t" ' 
        BEGIN {a=0; b=0; c=0; }
        $6!="Age" {
            if($6>=0&&$6<20) {a++;}
            else if($6<=30) {b++;}
            else {c++;}
        }
        END {
            sum=a+b+c;
            printf("Age\tNumber\tPercentage\n");
            printf("<20\t%d\t%f%%\n",a,a*100.0/sum);
            printf("[20,30]\t%d\t%f%%\n",b,b*100.0/sum);
            printf(">30\t%d\t%f%%\n",c,c*100.0/sum);
        }' worldcupplayerinfo.tsv

}

#统计不同场上位置的球员数量、百分比
function count_location {
    awk -F "\t" '
        BEGIN {a=0;b=0;c=0;d=0;sum=-1;}
        {
            sum++;
            if($5=="Goalie"){a++;}
            else if($5=="Defender"){b++;}
            else if($5=="Midfielder"){c++;}
            else{d++}
        }
        END {
                printf("Location\tNumber\tPercentage\n");
                printf("Goalie\t\t%d\t%f%%\n",a,a*100.0/sum);
                printf("Defender\t%d\t%f%%\n",b,b*100.0/sum);
                printf("Midfielder\t%d\t%f%%\n",c,c*100.0/sum);
                printf("Forward\t\t%d\t%f%%\n",d,d*100.0/sum);
        }' worldcupplayerinfo.tsv
     
}

#名字最长的球员是谁？名字最短的球员是谁？
#考虑并列
function Maxname {
    awk -F "\t" '
        BEGIN {mx=-1;mi=1000;}
        {
            len=length($9);
            names[$9]=len;
            mx=len>mx?len:mx;
            mi=len<mi?len:mi;
        }
        END {
            for(i in names) {
                if(names[i]==mx){
                printf("The longest name is %s\n", i);
                } else if(names[i]==mi) {
                    printf("The shortest name is %s\n", i);
                }
            }
        }' worldcupplayerinfo.tsv
}

#年龄最大的球员是谁？年龄最小的球员是谁
#考虑并列
function Maxage {
    awk -F "\t" '
        BEGIN {mx=-1; mi=1000}
        NR>1 {
            age=$6;
            names[$9]=age;
            mx=age>mx?age:mx;
            mi=age<mi?age:mi;
        }
        END {
            printf("The eldest age is %d, who is\n", mx);
            for(i in names) {
                if(names[i]==mx){
                    printf("%s\n", i);
                }
            }
            printf("The youngest age is %d, who is\n",mi);
            for(i in names){
                if(names[i]==mi){
                    printf("%s\n", i);
                }
            }
            
        }' worldcupplayerinfo.tsv
}


while [ "$1" != "" ] ;do
    case "$1" in
        "-a")
            count_age
            exit 0
            ;;
        "-l")
            count_location
            exit 0
            ;;
        "-n")
            Maxname
            exit 0
            ;;
        "-m")
            Maxage
            exit 0
            ;;
        "-h")
            help
            exit 0
            ;;
    esac
done