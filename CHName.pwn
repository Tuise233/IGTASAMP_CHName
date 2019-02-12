/*
IGTASAMP - 简易称号系统 By IGTA褪色
使用方法:
        /setch [玩家ID] [称号] - 添加一个玩家称号
        /delch [玩家ID] - 删除一个玩家称号

注意事项：
        请自行在scriptfiles文件夹目录下添加ch文件夹，否则使用该指令会导致服务器崩溃!!!

最后修改:
        2019.2.12 14:53
*/


#include <a_samp>
#include <sscanf>
#include <izcmd>

#define COLOR_VIP 0x09F709C8

public OnFilterScriptInit()
{
    printf("-----| 简易称号系统 |-----");
    printf("-----|   By 褪色   |-----");
    return 1;
}

public OnPlayerText(playerid, text[])
{
    new files[64],name[64],info[64],pText[256];
    GetPlayerName(playerid,name,sizeof(name));
    format(files,sizeof(files),"\\ch\\%s.tuise",name);
    if(fexist(files))
    {
        new File:fl = fopen(files);
        fread(fl,info); //获取玩家称号
        format(pText,sizeof(pText),"%s%s(%d):%s",info,name,playerid,text);
        SendClientMessageToAll(COLOR_VIP,pText);
        return 0;
    }
    return 0;
}

COMMAND:setch(playerid,params[]) //设置玩家称号
{
    new name[64],files[64],string[128],ch[64],aname[64],pid[18];
    if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,COLOR_VIP,"[称号系统]您不是管理员");
    if(sscanf(params,"s[18]s[64]",pid,ch)) return SendClientMessage(playerid,COLOR_VIP,"[称号系统]添加一名玩家的称号:/setch [玩家ID] [称号]");
    if(!GetPlayerName(strval(pid),name,sizeof(name))) return SendClientMessage(playerid,COLOR_VIP,"[称号系统]当前玩家不在线");
    GetPlayerName(strval(pid),name,sizeof(name)); //获取玩家昵称
    GetPlayerName(playerid,aname,sizeof(aname)); //获取管理员昵称
    format(files,sizeof(files),"\\ch\\%s.tuise",name);
    format(ch,sizeof(ch),"[%s]",ch); //给管理员设置的称号字符串加上小括号[ ]
    format(string,sizeof(string),"[称号系统]管理员%s(%d)修改玩家%s(%d)称号为:%s",aname,playerid,name,strval(pid),ch);
    if(fexist(files)) //如果该玩家以前就有称号
    {
        fremove(files); //删除原称号数据
        new File:fl = fopen(files);
        fwrite(fl,ch); //写入玩家昵称
        fclose(fl);
        SendClientMessageToAll(COLOR_VIP,string);
        return 1;
    }
    new File:fl = fopen(files);
    fwrite(fl,ch);
    fclose(fl);
    SendClientMessageToAll(COLOR_VIP,string);
    return 1;
}

COMMAND:delch(playerid,params[]) //删除玩家称号
{
    new name[64],aname[64],string[128],files[64],pid[18];
    if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,COLOR_VIP,"[称号系统]您不是管理员");
    if(sscanf(params,"s[18]",pid)) return SendClientMessage(playerid,COLOR_VIP,"[称号系统]删除一名玩家的称号:/setch [玩家ID]");
    if(!GetPlayerName(strval(pid),name,sizeof(name))) return SendClientMessage(playerid,COLOR_VIP,"[称号系统]当前玩家不在线");
    GetPlayerName(strval(pid),name,sizeof(name)); //获取玩家昵称
    GetPlayerName(playerid,aname,sizeof(aname)); //获取管理员昵称
    format(files,sizeof(files),"\\ch\\%s.tuise",name);
    format(string,sizeof(string),"[称号系统]管理员%s(%d)删除玩家%s(%d)的称号",aname,playerid,name,strval(pid));
    if(!fexist(files)) return SendClientMessage(playerid,COLOR_VIP,"[称号系统]当前玩家没有称号");
    fremove(files);
    SendClientMessageToAll(COLOR_VIP,string);
    return 1;
}
