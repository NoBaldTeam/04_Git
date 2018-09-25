# Git客户端问题手册

### 1.1注册完邮箱，直接点reload激活会报错
直接点reload激活报错：
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%871.png" width="80%"> </p>
复制下面收到的地址到网页打开（包括两个等号，不要直接点击链接），才可以成功激活：
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%872.png" width="80%"> </p>
### 1.2 Commit时出现未配置用户提示：

原因：是因为没有配置用户姓名和邮箱，用下面命令配置一下
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%873.png" width="80%"> </p>

由于部分原因，即使配置了上面的命令，但commit里依然报错，用git config –l查看配置时，没有显示出所配置的项，相当于所执行的命令没有成功（即使执行命令时未报错），可以采用如下的方式解决：
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%874.png" width="80%"> </p>
在当用户下新建vi .gitconfig，输入如下内容即可：
[user]
        name = system1
        email = weifeng.liu@itel-mobile.com
[color]
        ui = auto

### 1.3 push时提示邮箱不匹配
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%875.png" width="80%"> </p>
原因分析：
Git中配置的邮箱与gerrit上配置的邮箱不一致。
解决：
在git或gerrit重新配置邮箱，让这两个地方的邮箱保持一致即可。
有时即使一致，也可能会出现不一致的现象，可以删除下载的git库，重新下载即可。

### 1.4 push进gerrit时报错（没有拷贝钩子脚本）
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%876.png" width="80%"> </p>
原因分析：可能是第一次push时没有拷贝钩子脚本到本地，所以没产生change-ID，所以不允许push
解决：拷贝钩子脚本，用git commit –amend重新提交后，再推送：

拷贝钩子脚本：
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%877.png" width="80%"> </p>
此时直接推送还是会报错，需要先用git commit --amend重新提交一次再推送（执行命令后，直接按esc键，再输入：和q退出即可）：
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%878.png" width="80%"> </p>

如果不是当前的commit没有change-id，需要先看一下是哪个commit没有change-id，回退到没有change-id的前一个commit号，再重新commit和push
回退命令：git reset --soft commit-id

### 1.5 push报错
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%879.png" width="80%"> </p>
是因为开发人员没有push merge的权限，在gerrit上开了这个权限就可以了。
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8710.png" width="80%"> </p>

### 1.6 push进gerrit报错：
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8711.png" width="80%"> </p>

<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8712.png" width="80%"> </p>

解决：先用git commit –amend重新提交（运行后输入：q退出即可），再想gerrit推送，如下：
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8713.png" width="80%"> </p>

### 1.7 提示没有权限：
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8714.png" width="80%"> </p>
原因分析：没有将公钥加入进gerrit中，或是生成的公钥有问题

### 1.8 添加勾子脚本提示需要输入密码：
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8715.png" width="80%"> </p>
原因分析：把scp –P写成了scp –p，改成-P即可。

### 1.9 如何查看repo有哪些分支：
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8716.png" width="80%"> </p>
解决方法：
登录gerrit—>projects—>list，选择自己有权限的repo库，点击branches就可以看到repo库有的分支
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8717.png" width="80%"> </p>

### 1.10 git log显示：bad default revision 'HEAD'
$ git log #查看当前仓库的历史日志 
fatal: bad default revision 'HEAD'
原因分析：由于仓库里没有任提交在里面，所以它会报这个错。
解决方法：执行一次commit之后就不会有这个提示了

### 1.11 push报错，non-fast-forward
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8718.png" width="80%"> </p>
原因分析：在push到远程分支前没有更新本地版本库当前分支的代码。
解决方法：
第一种：git pull --rebase 【远程版本库】【需要push的分支】
如：git pull --rebase itel mt6580_int
第二种方法：
先更新本地版本库：git remote update
将远程分支内容变基到本地当前分支：git rebase 【远程版本库】/【需要push的分支】
如：git rebase itel/ mt6580_int

### 1.12 公钥不生效
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8719.png" width="80%"> </p>
用ssh新生成了key，然后在Gerrit里面也添加了这个刚生成的key，但是在本地虚拟机里面不能测试通过ssh连接。
解决方法：
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8720.png" width="80%"> </p>
使用了一个命令： ssh-add  id_rsa
把那个密钥文件添加进来就可以了。
或者将.ssh文件夹全部删除掉，然后再重新生成。

### 1.13 reposync报错
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8721.png" width="80%"> </p>
原因分析：本地的分支上有repo库还处于rebase出现冲突的状态，
解决方法：在repo库中执行git rebase --abort或rebase完成后可以正常sync。

### 1.14 cherry-pick方法
可以指定push某些commit-id，指定的commit-id必须是自己提交的，不要挑选自动合并产生的
下面举例将提交到开发流的commit-id挑到Int流：
1.基于debug分支clone的git库，使用git log查看，先记录需要挑选的commit-id；
2.git remote update
3.git checkout -b 【个人分支名】 remotes/origin/mt6580_int
4.git cherry-pick commit-id      （要push的commit-id，从旧到新）
git cherry-pick commit-id
……
5.git push origin HEAD:refs/for/mt6580_int

### 1.15 push报错：squash commits first
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8722.png" width="80%"> </p>
原因分析：
在进行cherry-pick时，挑选的commit-id描述都一样，push时会提示如上错误
解决方法：
使用git reset --soft commit-id（回退到挑选的commit之前的commit-id）
git status
git commit –s –m “活动描述”
git push 【远程版本库】HEAD:【远程分支】

### 1.16 push报错：
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8723.png" width="80%"> </p>
原因分析：push的远程版本库名称写错了
解决方法：使用git remote –v查看远程版本库名

### 1.17 新建分支报错
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8724.png" width="80%"> </p>
原因分析：某个分支提交出现过不完整，然后在当前分支创建新分支时提示的这种错误，而且只能选择N。
解决方法：可以另外切到其他好的本地分支，再创建新分支就没有问题，如果切换回有问题的分支，创建基于任何远程分支的本地分支都会提示那个确认选择。

### 1.18 push报错（没有sign-off-by）
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8725.png" width="80%"> </p>
原因分析：在commit时没有带-s参数，没有生成sign-off-by
解决方法：
1.git log查看没有带签名的commit，记录该commit前一次的commit-id
2.git reset --soft commit-id
3.git add .
4.git commit -s -m “活动描述”
5.git push origin HEAD:远程分支名

### 1.19 在windows下配置beyond compare 3工具
Git工具配置 – BeyondCompare
•Diff工具配置 
–git config --global diff.tool bcom3
–git config --global difftool.bcom3.cmd "\"c:/program files/beyond compare 3/bcomp.exe\" \"$LOCAL\" \"$REMOTE\"“
–git config --global difftool.prompt false
•Merge工具配置 
–git config --global merge.tool bcom3
–git config --global mergetool.bcom3.cmd "\"c:/program files/beyond compare 3/bcomp.exe\" \"$LOCAL\" \"$REMOTE\" \"$BASE\" \"$MERGED\"“
–git config --global mergetool.bcom3.trustExitCode true
•检查 
–git config --global -e 打开编辑界面检查是否命令参数配置正常了 
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8726.png" width="80%"> </p>
使用方法：
Diff工具：git difftool 【commit_id1】 【commit_id2】
Merge工具：当代码发生冲突时，使用git mergetool命令，回车默认选择bcom3工具：
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8727.png" width="80%"> </p>
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8728.png" width="80%"> </p>

上面三个窗口依次是“LOCAL”、“BASE”、“REMOTE”，它们只是提供解决冲突需要的信息，是无法编辑的。下面一个窗口是合并后的结果，可以手动修改，也可以点击相应颜色的箭头选择“LOCAL”或者“REMOTE”。
启动Beyond Compare之后，会自动生成几个包含大写字母名称、数字的辅助文件：
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8729.png" width="80%"> </p>
关闭Beyond Compare时，这几个辅助文件都会自动删除，但同时会生成一个.orig的文件，内容是解决冲突前的冲突现场。默认该.orig文件可能不会自动删除，需要手动删掉。

### 1.20 解决打带日志的补丁时报whitespace问题
原因分析：windows下和linux下的文件格式不统一，在windows下产生\r\n,\t,空格等whitesapce字符。
解决方法：
在使用git bash时，配置项默认为第一项，现将其调整到第二项
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8730.png" width="80%"> </p>

### 1.21 在push到gerrit上时，评审通过，但是代码无法merge

原因分析：需要merge的任务有依赖的任务，而所依赖的任务已经被abandon了，导致当前的代码无法merge到提交分支
解决方法步骤：
1.点击abandon的任务，查看commit-id
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8731.png" width="80%"> </p>
2.在本地的代码库中，使用git log查看abandon的commit-id前的一个commit-id
3.使用git reset --soft回退到abandon的commit-id前的一个commit-id；
4.重新进行add，commit，push，产生新的gerrit任务
5.将之前有问题的任务也abandon掉
1.22 在git中添加不了空目录
解决方法步骤：
1.在空目录下创建.gitignore文件，在文件内写入以下代码，可以排除空目录下所有文件被跟踪：
# Ignore everything in this directory
*
# Except this file !.gitignore
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8732.png" width="80%"> </p>
2.使用git status查看
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8733.png" width="80%"> </p>

### 1.23 无法修改git commit信息
原因分析：使用git命令时，没有编辑器可以使用
解决方法步骤：
1.进入到git库中，编辑.git/config文件，在【core】中添加：
editor = vi
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8734.png" width="80%"> </p>

2.使用git config --global -e编辑全局配置文件，添加：
【core】
editor = vi
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8735.png" width="80%"> </p>



### 1.24 push到远程分支报错：

<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8736.png" width="80%"> </p>
原因：git服务器上的远程分支有更新，本地没有跟服务器同步
解决：用git pull –rebase同步一下再推送，如下：

<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8737.png" width="80%"> </p>


### 1.25 Submit失败，提示rebase或merge解决冲突： git pull –rebase报错
先用git pull - -rebase更新代码,解决提示有冲突的文件:
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8738.png" width="80%"> </p>
修改有冲突的cc1.txt，运行git add. Git rebase –continue：

<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8739.png" width="80%"> </p>
Rebase成功之后再push进gerrit。

### 1.26 push多个commit，中间有问题，如何解决？（用git rebase –i）
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8740.png" width="80%"> </p>
用git rebase –i对以前的多个提交进行修改
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8741.png" width="80%"> </p>

<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8742.png" width="80%"> </p>

<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8743.png" width="80%"> </p>

修改有问题文件的代码：


<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8744.png" width="80%"> </p>
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8745.png" width="80%"> </p>

解决由于修改有问题代码产生的冲突（第三次修改）：
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8746.png" width="80%"> </p>

### 1.27 查看已暂存和未暂存的更新（git diff 和git diff --cached）
git status命令仅仅是列出了修改过的文件，如果要查看具体修改了什么地方，就要用到git diff命令。

下面新跟踪了一个ph.xml文件，暂存之后发现还需要修改，就又重新编辑了一下，在暂存这次修改之前，运行git status命令如下：


<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8747.png" width="80%"> </p>

要查看尚未暂存的文件更新了哪些部分，不加参数直接输入git diff：

<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8748.png" width="80%"> </p>
以上可以看到更新的内容为插入了一行代码。

说明：仅仅是git diff命令只是显示还没有暂存起来的改动，而不是这次工作和上次提交之间的差异。所以有时候暂存了所有的文件之后，运行git diff后什么都没有。

如果想查看这次工作和上次提交之间的差异，需要用git diff –cached:

下面例子中，test和ph.xml文件都已经提交（git commit后面会详细提到）过，然后再对两个文件进行修改，暂存（git add），然后运行git diff命令：（注意此处比较的是暂存后的工作和提交之前的差异，如果文件修改了但是没有用git add暂存，那么修改的这部分内容是不会出现在差异中的。）



<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8749.png" width="80%"> </p>
以上可以看到两个文件现在的工作和提交之前的对比情况。

### 1.28 git cherry-pick有冲突解决：
git cherry-pick过程中报错如下：

<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8750.png" width="80%"> </p>



运行git status查看有冲突文件：
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8751.png" width="80%"> </p>


注意：如果是可编辑文件，直接打开有冲突文件，手动解决冲突，解决后保存退出；
      如果是二进制类不可编辑文件，可以将本地文件直接覆盖进本地git库相应目录，
然后运行
git add .  或git add 文件名
git commit –c commit-id（这里的commit-id即为刚才cherry-pick时用到的commit-id）如下：


<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8752.png" width="80%"> </p>
然后再push到gerrit即可。

### 1.29 git reset
用git log --pretty=oneline -n查看最近几次的commit-ID：

<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8753.png" width="80%"> </p>
用git reset [commit-ID]回退到最早的一个commit-ID上：


<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8754.png" width="80%"> </p>
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8755.png" width="80%"> </p>
然后用git add .(或具体文件)，git commit –amend重新提交，然后push。

git reset commit-ID (需要用git add git commit)
 git reset --soft commit-ID(需要用git commit)
 git reset --hard comit-ID(工作区、暂存区，数据库中都被删除） 
( reset后注意使用git commit –amend 还是git commit –s –m “”)

### 1.30 查看要评审的任务是否是按正常流程提交进gerrit
（在开发分支上修改cherry-pick进Int分支，而不是直接在Int分支上修改）
使用图形化工具gitk查看提交历史，在命令界面直接运行gitk，可查看Debug Branch和Int Branch的活动
例如：先切换到debug分支：可以看到这个分支上所有的提交（commit）
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8756.png" width="80%"> </p>

### 1.31 针对同一个文件的修改，用- -amend提交
针对同一个文件或同一个问题的修改，尽量使用一次commit提交，如果需要多次提交，可以使用git commit --amend进行提交，即使用前次提交的日志重新提交； 

### 1.32开发人员工作方式建议：
建议开多个分支同时工作 ，个人本地分支最好能按照需要处理的bug建立单独的分支（每个bug一个分支），这样避免了只维护一个本地分支时，修改之间可能会产生依赖。这个情况在add和remove文件之后，有可能会发生。
如果某个分支提交的活动还未完成从Gerrit submit，此时后续的修改应创建新分支，在新分支上继续修改 
同一个分支上的修改应等待上一次的变更被submit后才能继续提交，避免Gerrit上变更出现活动依赖 
本条分支上面的变更需要重新修改后再次push时，不要创建新的提交，用git  commit –amend复用上次的变更记录ID 
先更新，再提交
按最小功能（或是单功能）提交代码，每次提交以完成一项功能为宜，添加一个小特性或修复一个 bug 。在开发功能模块的时候，每个小功能的测试通过后，进行一次提交。
pretest-push-不要提交未完成的代码，提交到主线分支之前，首先要在本地做过编译和验证

### 1.33 push到gerrit或者debug分支时报如下错误:
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8757.png" width="80%"> </p>
分析原因:是由于git版本太高导致,目前gerrit版本是2.7,安装1.8以下的git版本不会出现上面问题.

### 1.34 在push时提示LOCK_FAILURE报错
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8758.png" width="80%"> </p>
出现此问题后，需要更新下当前的代码环境git pull，然后再重新提交，若还有问题，需要删除此代码目录，重新下载代码—拷贝commit-msg---再修改代码、提交、push

### 1.35 Sme走读后无法submit
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8759.png" width="80%"> </p>
现象如上图，经过排查，为gerrit服务端权限配置问题，需要添加submit权限为register users

### 1.36 在同一用户下下载其它帐户的代码
一般情况下，添加密钥是以前用户生成的，在clone命令中不添加用户名就可以直接下载代码，但有时由于用户名的改变，就无法下载代码，需要在clone命令前加上用户名：
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8760.png" width="80%"> </p>

还有一种方法如下：
添加 vi ~/.ssh/config  文件中，添加类似：User xingui.yang，即可直接使用命令，而不用再添加用户名。

### 1.37 Commit信息超长报错
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8761.png" width="80%"> </p>
提示commit信息超长，通过git commit –amend修改commit信息后再提交即可。

### 1.38 Cherry-pick，修改文件后push出错：
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8762.png" width="80%"> </p>
无论怎么重复下载、修改，都报错，无法正常提交、
使用git commit –amend后，查看活动名底下有几行修改文件的记录，将其删除保存退出，再push即可
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8763.png" width="80%"> </p>

### 1.39 使用repo sync代码时，个别repo下载出错
如下图所示：
<p align="center"> <img src="http://pfll6cwh2.bkt.clouddn.com/%E5%9B%BE%E7%89%8764.png" width="80%"> </p>

无论重新init或sync，都会报错类似的错，可能此repo下载中出现异常。
解决方法：
1、先删除此代码文件夹PackageInstaller(以上面报错的为例)
2、再回到代码的主止录下，即mt6737-39_8.1下，删除当前路径下对应的.git文件夹：.repo/projects/packages/apps/PackageInstaller.git
3、再返回主目录重新sync即可