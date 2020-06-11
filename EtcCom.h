
#include "gv_load_obu_api.h"
#include "gv_load_cpuCard_api.h"
#include "commdef.h"
#include "OBUIssue.h"

//obu操作初始化
extern "C" __declspec(dllexport) BOOL obuInit(char* dev,int readPsamSlot,int wrietPsamSlot,int readerType,int txPower);  
//关闭obu操作
extern "C" __declspec(dllexport) void obuClose();  
//读取obu系统信息
extern "C" __declspec(dllexport) BOOL getObuSysInfo(SysInfoType *sysInfoType);
//读取obu车辆信息
extern "C" __declspec(dllexport) BOOL getObuVehInfo(OBUVehicleInfoType *OBUVehicleInfoType,int disperseCount);
//更新obu系统信息
extern "C" __declspec(dllexport) BOOL updateObuSysInfo(SysInfoType *sysInfoType);
extern "C" __declspec(dllexport) BOOL updateObuSysInfoGetRandom(char *randomNum);
extern "C" __declspec(dllexport) BOOL updateObuSysInfoByMac(SysInfoType *sysInfoType,char *mac);
//更新obu车辆信息
extern "C" __declspec(dllexport) BOOL updateObuVehInfo(OBUVehicleInfoType *OBUVehicleInfoType);
extern "C" __declspec(dllexport) BOOL updateObuVehInfoGetRandom(char *randomNum);
extern "C" __declspec(dllexport) BOOL updateObuVehInfoByMac(OBUVehicleInfoType *OBUVehicleInfoType,char *mac);
//OBU人机界面
extern "C" __declspec(dllexport) BOOL esam_Done();


//cpuCard操作初始化
extern "C" __declspec(dllexport) BOOL cpuCardInit(int com,int psamSlot,int readerType);
//关闭cpuCard操作
extern "C" __declspec(dllexport) void cpuCardClose();
//读取金额
extern "C" __declspec(dllexport) BOOL getCpuCardMoney(char* money);
//读取cpuCard 19文件
extern "C" __declspec(dllexport) BOOL getCpuCard0019File(TCard_0019 *cpuCard0019File);
//读取cpuCard 15文件
extern "C" __declspec(dllexport) BOOL getCpuCard0015File(TCard_0015 *cpuCard0015File);
//读取cpuCard 16文件
extern "C" __declspec(dllexport) BOOL getCpuCard0016File(TCard_0016 *cpuCard0016File);
//更新cpuCard 15文件
extern "C" __declspec(dllexport) BOOL updateCpuCard0015File(TCard_0015 *cpuCard0015File);
extern "C" __declspec(dllexport) BOOL updateCpuCard0015FileGetRandom(char *randomNum);
extern "C" __declspec(dllexport) BOOL updateCpuCard0015FileByMac(TCard_0015 *cpuCard0015File,char *mac);
//更新cpuCard 16文件
extern "C" __declspec(dllexport) BOOL updateCpuCard0016File(TCard_0016 *cpuCard0016File);
extern "C" __declspec(dllexport) BOOL updateCpuCard0016FileGetRandom(char *randomNum);
extern "C" __declspec(dllexport) BOOL updateCpuCard0016FileByMac(TCard_0016 *cpuCard0016File,char *mac);

extern "C" __declspec(dllexport) BOOL cpuCardLoadInit(int money,char *terminal,char *randomNum,char *transNumber);
extern "C" __declspec(dllexport) BOOL cpuCardLoad(char *mac,char *tac);

extern "C" __declspec(dllexport) BOOL cpuCardPurChaseInit(int money,char *terminal,char *randomNum,char *transNumber);
extern "C" __declspec(dllexport) BOOL cpuCardPurChase(char *mac,char *tac,char *terminalTransation);

//释放OBU链接
BOOL eventReport();


//读取obu系统信息 
BOOL esam_getSysInfo();
//执行obu指令
BOOL esam_Exec(char *cmd,int strLen);
//执行psam指令
BOOL psam_Exec(char *cmd,int psamSlot,int strLen);
//初始化obu连接
BOOL initialisation();
//检测返回值是否成功
BOOL checkResult(char * strResult);
//psam选择目录
BOOL psam_SelectedDir(int psamSlot,char *cmd);
//psam获取随机数
BOOL psam_GetRandomNum(int psamSlot,int numLen,char *randomNum);
//esam选择目录
BOOL esam_SelectedDir(char *cmd);
//esam获取随机数
BOOL esam_GetRandomNum(int numLen,char *randomNum);
//获取obu车辆信息内容
BOOL esam_GetVehValue(char *vehValue);
//psam 重置
BOOL psam_reset(int psamSlot);
//psam 解密初始化
BOOL psam_DesDecInit(int psamSlot,int disperseCount);
//psam mac初始化
BOOL psam_DesMacInit(int psamSlot,int updateType,int readerType);
//psam 解密
BOOL psam_Dec(int psamSlot, char *decValue,int disperseCount);

void hs2bsAtSys(TOBUSystemInfo* hs,SysInfoType* bs);
void bs2hsSys(SysInfoType* bs,TOBUSystemInfo* hs);
void hs2bsAtVeh(TOBUVehicleInfo* hs,OBUVehicleInfoType* bs);
void bs2hsAtVeh(OBUVehicleInfoType* bs,TOBUVehicleInfo* hs);

