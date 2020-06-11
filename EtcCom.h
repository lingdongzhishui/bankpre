
#include "gv_load_obu_api.h"
#include "gv_load_cpuCard_api.h"
#include "commdef.h"
#include "OBUIssue.h"

//obu������ʼ��
extern "C" __declspec(dllexport) BOOL obuInit(char* dev,int readPsamSlot,int wrietPsamSlot,int readerType,int txPower);  
//�ر�obu����
extern "C" __declspec(dllexport) void obuClose();  
//��ȡobuϵͳ��Ϣ
extern "C" __declspec(dllexport) BOOL getObuSysInfo(SysInfoType *sysInfoType);
//��ȡobu������Ϣ
extern "C" __declspec(dllexport) BOOL getObuVehInfo(OBUVehicleInfoType *OBUVehicleInfoType,int disperseCount);
//����obuϵͳ��Ϣ
extern "C" __declspec(dllexport) BOOL updateObuSysInfo(SysInfoType *sysInfoType);
extern "C" __declspec(dllexport) BOOL updateObuSysInfoGetRandom(char *randomNum);
extern "C" __declspec(dllexport) BOOL updateObuSysInfoByMac(SysInfoType *sysInfoType,char *mac);
//����obu������Ϣ
extern "C" __declspec(dllexport) BOOL updateObuVehInfo(OBUVehicleInfoType *OBUVehicleInfoType);
extern "C" __declspec(dllexport) BOOL updateObuVehInfoGetRandom(char *randomNum);
extern "C" __declspec(dllexport) BOOL updateObuVehInfoByMac(OBUVehicleInfoType *OBUVehicleInfoType,char *mac);
//OBU�˻�����
extern "C" __declspec(dllexport) BOOL esam_Done();


//cpuCard������ʼ��
extern "C" __declspec(dllexport) BOOL cpuCardInit(int com,int psamSlot,int readerType);
//�ر�cpuCard����
extern "C" __declspec(dllexport) void cpuCardClose();
//��ȡ���
extern "C" __declspec(dllexport) BOOL getCpuCardMoney(char* money);
//��ȡcpuCard 19�ļ�
extern "C" __declspec(dllexport) BOOL getCpuCard0019File(TCard_0019 *cpuCard0019File);
//��ȡcpuCard 15�ļ�
extern "C" __declspec(dllexport) BOOL getCpuCard0015File(TCard_0015 *cpuCard0015File);
//��ȡcpuCard 16�ļ�
extern "C" __declspec(dllexport) BOOL getCpuCard0016File(TCard_0016 *cpuCard0016File);
//����cpuCard 15�ļ�
extern "C" __declspec(dllexport) BOOL updateCpuCard0015File(TCard_0015 *cpuCard0015File);
extern "C" __declspec(dllexport) BOOL updateCpuCard0015FileGetRandom(char *randomNum);
extern "C" __declspec(dllexport) BOOL updateCpuCard0015FileByMac(TCard_0015 *cpuCard0015File,char *mac);
//����cpuCard 16�ļ�
extern "C" __declspec(dllexport) BOOL updateCpuCard0016File(TCard_0016 *cpuCard0016File);
extern "C" __declspec(dllexport) BOOL updateCpuCard0016FileGetRandom(char *randomNum);
extern "C" __declspec(dllexport) BOOL updateCpuCard0016FileByMac(TCard_0016 *cpuCard0016File,char *mac);

extern "C" __declspec(dllexport) BOOL cpuCardLoadInit(int money,char *terminal,char *randomNum,char *transNumber);
extern "C" __declspec(dllexport) BOOL cpuCardLoad(char *mac,char *tac);

extern "C" __declspec(dllexport) BOOL cpuCardPurChaseInit(int money,char *terminal,char *randomNum,char *transNumber);
extern "C" __declspec(dllexport) BOOL cpuCardPurChase(char *mac,char *tac,char *terminalTransation);

//�ͷ�OBU����
BOOL eventReport();


//��ȡobuϵͳ��Ϣ 
BOOL esam_getSysInfo();
//ִ��obuָ��
BOOL esam_Exec(char *cmd,int strLen);
//ִ��psamָ��
BOOL psam_Exec(char *cmd,int psamSlot,int strLen);
//��ʼ��obu����
BOOL initialisation();
//��ⷵ��ֵ�Ƿ�ɹ�
BOOL checkResult(char * strResult);
//psamѡ��Ŀ¼
BOOL psam_SelectedDir(int psamSlot,char *cmd);
//psam��ȡ�����
BOOL psam_GetRandomNum(int psamSlot,int numLen,char *randomNum);
//esamѡ��Ŀ¼
BOOL esam_SelectedDir(char *cmd);
//esam��ȡ�����
BOOL esam_GetRandomNum(int numLen,char *randomNum);
//��ȡobu������Ϣ����
BOOL esam_GetVehValue(char *vehValue);
//psam ����
BOOL psam_reset(int psamSlot);
//psam ���ܳ�ʼ��
BOOL psam_DesDecInit(int psamSlot,int disperseCount);
//psam mac��ʼ��
BOOL psam_DesMacInit(int psamSlot,int updateType,int readerType);
//psam ����
BOOL psam_Dec(int psamSlot, char *decValue,int disperseCount);

void hs2bsAtSys(TOBUSystemInfo* hs,SysInfoType* bs);
void bs2hsSys(SysInfoType* bs,TOBUSystemInfo* hs);
void hs2bsAtVeh(TOBUVehicleInfo* hs,OBUVehicleInfoType* bs);
void bs2hsAtVeh(OBUVehicleInfoType* bs,TOBUVehicleInfo* hs);

