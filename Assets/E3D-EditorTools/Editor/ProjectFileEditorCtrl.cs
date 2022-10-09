//******************************************************
//
//	文件名 	: 		ProjectFileEditorCtrl.cs
//	
//	脚本创建者	:		微尘道人

//	创建时间 :		2019年8月12日 10:30
//******************************************************
using System.Text;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

/// <summary>
/// 工程师图，文件剪切/文件粘贴，获取当前路径
/// </summary>
public class ProjectFileEditorCtrl : Editor
{
    /// <summary>
    /// Cache All Files Path
    /// 缓存所有文件路径
    /// </summary>
    static List<string> _cutFiles = new List<string>();

    [MenuItem("Assets/剪切文件")]
    public static void CutFiles()
    {
        //清空缓存
        _cutFiles.Clear();

        //获取通过鼠标选中的文件
        foreach (var obj in Selection.objects)
        {
            //添加文件路径到缓存
            _cutFiles.Add(AssetDatabase.GetAssetPath(obj));
        }

        // 移除重叠目录文件
        for (int i = _cutFiles.Count - 1; i >= 0; --i)
        {
            for (int j = 0; j < _cutFiles.Count; ++j)
            {
                if (i != j && _cutFiles[i].Contains(_cutFiles[j]))
                {
                    _cutFiles.RemoveAt(i);
                    break;
                }
            }
        }
    }

    public static void RefreshCutFiles()
    {
        _cutFiles.Clear();
    }

    [MenuItem("Assets/粘贴文件")]
    public static void PasteFiles()
    {
        //粘贴的路径为空,就直接返回
        if (Selection.objects.Length != 1)
        {
            return;
        }
        //获取第一个对象的路径
        string dir = AssetDatabase.GetAssetPath(Selection.objects[0]);

        for (int i = _cutFiles.Count - 1; i >= 0; --i)
        {
            string file = _cutFiles[i];
            string target = Path.Combine(dir, Path.GetFileName(file));//生成剪切文件的粘贴路径 
            string validate = AssetDatabase.ValidateMoveAsset(file, target);//验证移动资源 
            if (validate == string.Empty && AssetDatabase.MoveAsset(file, target) == string.Empty) //移动资源  
            {
                _cutFiles.RemoveAt(i);
            }
            else
            {
                Debug.LogError("移动文件报错:" + validate);
            }
        }
        //刷新资源视图
        AssetDatabase.Refresh();

        //清空缓存
        RefreshCutFiles();  
    }

    [MenuItem("Assets/当前资源路径")]
    static void GetSelectObjPath()
    {
        var _obj = Selection.activeObject;
        var _objPath = AssetDatabase.GetAssetPath(_obj);
        string str = _obj ? "当前资源路径是：" + _objPath:"当前资源路径是:Asset";
        Debug.Log(str);
    }
}
