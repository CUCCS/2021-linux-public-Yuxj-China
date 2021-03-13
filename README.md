# Linux第一次作业

## 实验报告：

实验目标：在Virtualbox上分别尝试手动安装和无人值守安装Ubuntu 20.04.2 Linux系统；

实验对象：纯净Ubuntu 20.04.2 live-server-amd64.iso镜像文件；

实验过程：从官网下载镜像文件，SHA256检测文件完整性，对照视频进行手动安装和无人值守安装。

实验问题回答：

1，如何配置无人值守安装iso，并在Virtualbox中完成自动化安装。

-在“设置-存储-控制器”中移除IDE，在SATA里先后挂载Ubuntu 20.04和init.iso，设置网卡，具体自动化安装见实验步骤。

2，Virtualbox安装完Ubuntu之后新添加的网卡如何实现系统开机自动启用和自动获取IP？

-解决方法来源：https://blog.csdn.net/xiongyangg/article/details/110206220

添加新网卡后ip a，可见enp0s3、enp0s8正常工作，但enp0s9为失效：

![32](img/32.jpg)

原因是ubuntu20网络的配置信息将不在保存在/etc/network/interfaces文件中，虽然该文件依然存在，但是内容是空的。新系统已经使用netplan管理网络，对于配置信息，使用vim打开文件sudo vim /etc/netplan/00-installer-config.yaml，内容如下，可以看到网卡enp0s3、enp0s8下面有参数dhcp4: true：
            
![31](img/31.jpg)

说明网卡开启了dhch地址分配，但是并没有出现enp0s9，所以手动加入enp0s9，保存并退出：
            
![33](img/33.jpg)

执行sudo netplan apply，检查网卡ip地址，enp0s9有效：
            
![34](img/34.jpg)

3，如何使用sftp在虚拟机和宿主机之间传输文件？

-我实验过程中直接使用了老师课件仓库里的.iso文件，实验中如果自己制作的话，需要将路径var/log/installer/autoinstall-user-data下的文件拷贝出来：
            
![36](img/36.jpg)
            
![37](img/37.jpg)

修改文件属主：
            
![38](img/38.jpg)

拷贝完成，在文本文档中显示：
            
![40](img/40.jpg)


## 实验步骤图解：

创建虚拟机，动态分配内存可调整略大，这里调为70G：
        
![01](img/01.jpg)
        
![02](img/02.jpg)

        网卡设置：
        
![03](img/03.jpg)
        
![04](img/04.jpg)

设置存储盘片：
        
![05](img/05.jpg)

启动虚拟机后选择启动盘，点击启动：
        
![06](img/06.jpg)

检查盘片（这一步我第一次装的时候略过了，因为完成上一步后，我不小心使用截图的快捷键跳过了这一步，盘片没能检查，导致最后无人值守安装的时候一直卡在“installing kernel”即安装内核这一阶段，继续不下去，第二次实验完成了盘片的检查，安装才成功）：
        
![07](img/07.jpg)

语言选择Eng，后续选项保持默认选项：
        
![09](img/09.jpg)

网络连接设置里可以看出系统已经检测出连个网卡enp0s3、enp0s8：
        
![10](img/10.jpg)

不需要代理地址，直接访问网络：
        
![11](img/11.jpg)

默认镜像地址：
        
![12](img/12.jpg)

硬盘、分区默认：
        
![13](img/13.jpg)
        
![14](img/14.jpg)
        
![15](img/15.jpg)

全是cuc（因为之前有过装系统设置用户名密码，结果启动时忘掉的经历）：
        
![16](img/16.jpg)

无导入SSH公钥：
        
![17](img/17.jpg)

默认：
        
![18](img/18.jpg)

自动安装中：
       
![19](img/19.jpg)

手动安装完成：
        
![20](img/20.jpg)

成功登录：
        
![21](img/21.jpg)

尝试无人值守，使用刚才的虚拟机系统，移除其控制器IDE：
        
![22](img/22.jpg)

控制器SATA按顺序先后挂载ubuntu20.04、init.iso：
        
![23](img/23.jpg)

启动后等待：
        
![24](img/24.jpg)

Continue with autoinstall?(yes|no) yes [Enter]：
        
![25](img/25.jpg)

无人值守安装中：
        
![26](img/26.jpg)
        
![28](img/28.jpg)    
        
（这一步应该在配置其中的一个网卡：）
        
![27](img/27.jpg)

无人值守安装成功，并登录：
        
![29](img/29.jpg)

可实现ip a指令，得到两个网卡的ip地址和子网掩码：

![30](img/30.jpg)

## 问题和解决：

1.使用vim访问文件时，如果要修改，需要按“i”进入修改模式，修改后按“ESC+:+wq”保存并退出；

2.第一次手动安装时，在刚启动的阶段，虚拟机仍处于最上层，因为急着截图，按下快捷键，导致检查盘片的过程被跳过，最后配置文件阶段卡住，安装失败。第二次尝试，正确操作后，安装成功。