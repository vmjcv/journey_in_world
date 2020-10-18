#coding=utf-8
import sys
import requests 
import shutil
import zipfile
import os

def main(argv,chunk_size=1024*4):
    if argv[0]=="0":
        # 编辑器
        file_pname= "../godot/Godot.zip"
        url = 'https://downloads.tuxfamily.org/godotengine/3.2.2/Godot_v3.2.2-stable_win64.exe.zip' 
    elif argv[0]=="1":
        # 导出包
        file_pname= "../godot/Godot.tpz"
        url = 'https://downloads.tuxfamily.org/godotengine/3.2.2/Godot_v3.2.2-stable_export_templates.tpz' 
    download_file(url,file_pname)
    #download_file_callback(file_pname)
     
def download_file(url, file_pname, chunk_size=1024*4):
    """
    url: file url
    file_pname: file save path
    chunk_size: chunk size
    """
    # 第一种
    with requests.get(url, stream=True) as req:
        with open(file_pname, 'wb') as f:
            for chunk in req.iter_content(chunk_size=chunk_size):
                if chunk:
                    f.write(chunk)   
        download_file_callback(file_pname)

def unzip(filename: str):
    try:
        file = zipfile.ZipFile(filename)
        dirname = filename.replace('.zip', '')
        # 如果存在与压缩包同名文件夹 提示信息并跳过
        if os.path.exists(dirname):
            print(f'{filename} dir has already existed')
            return
        else:
            # 创建文件夹，并解压
            os.mkdir(dirname)
            file.extractall(dirname)
            file.close()
            # 递归修复编码
            rename(dirname)
    except:
        print(f'{filename} unzip fail')

def rename(pwd: str, filename=''):
    """压缩包内部文件有中文名, 解压后出现乱码，进行恢复"""
    
    path = f'{pwd}/{filename}'
    if os.path.isdir(path):
        for i in os.scandir(path):
            rename(path, i.name)
    newname = filename.encode('cp437').decode('gbk')
    os.rename(path, f'{pwd}/{newname}')

def download_file_callback(file_pname):
    if file_pname=="../godot/Godot.zip":
        unzip(file_pname)
        for root, dirs, files in os.walk("../godot/Godot"):
            print(os.path.join(root,files[0]))
            shutil.move(os.path.join(root,files[0]),"../godot/Godot.exe")  
            break
        os.unlink(file_pname)
        shutil.rmtree("../godot/Godot")
            
if __name__ == '__main__':      
    main(sys.argv[1:])
