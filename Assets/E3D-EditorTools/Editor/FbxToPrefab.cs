//******************************************************
//
//	文件名 	: 		SimpleFbxToPrefab.cs
//	
//	脚本创建者 	:		微尘道人 

//	创建时间 :		2019年8月12日 16:48
//******************************************************
using System.Text;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;


public class FbxToPrefab : Editor
{
    [MenuItem("Assets/Fbx转预置(不拆解)")]
    public static void SimpleChange()
    {
        GameObject selectedGameObject = Selection.activeGameObject;
        string selectedAssetPath = AssetDatabase.GetAssetPath(selectedGameObject);
        string _targetPath = selectedAssetPath.Substring(0, selectedAssetPath.LastIndexOf('/'));

        GameObject cloneObj = GameObject.Instantiate<GameObject>(selectedGameObject);
        cloneObj.name = cloneObj.name.Replace("(Clone)", string.Empty);
        string genPrefabFullName = string.Concat(_targetPath, "/", cloneObj.name, ".prefab");

        Object prefabObj = PrefabUtility.CreateEmptyPrefab(genPrefabFullName);
        GameObject prefab = PrefabUtility.ReplacePrefab(cloneObj, prefabObj);
        GameObject.DestroyImmediate(cloneObj);

        Debug.Log("Finish");
    }

    [MenuItem("Assets/Fbx转预置(拆解)")]
    private static void BatchPrefab()
    {
        float process = 0;
        int allLenth = 0;
        UnityEngine.Object _obj = Selection.activeObject;

        Transform parent = ((GameObject)_obj).transform;
        //获取当前FBX所在路径
        string _objPath = AssetDatabase.GetAssetPath(_obj);
        //截取生成预制的路径
        string _targetPath = _objPath.Substring(0, _objPath.LastIndexOf('/'));

        if (parent == null)
        {
            Debug.LogError("当前没有选中物体");
            return;
        }

        UnityEngine.Object tempPrefab;

        foreach (Transform t in parent)
        {
            allLenth++;
        }
        foreach (Transform t in parent)
        {
            string jindu = string.Format("正在生成，请耐心等待，当前进度:{0}%", ((process / allLenth) * 100).ToString("0.00"));
            tempPrefab = PrefabUtility.CreateEmptyPrefab(_targetPath + "/" + t.name + ".prefab");
            tempPrefab = PrefabUtility.ReplacePrefab(t.gameObject, tempPrefab);
            EditorUtility.DisplayCancelableProgressBar("生成进度条", jindu, process / allLenth);
            process++;
        }
        EditorUtility.ClearProgressBar();
        AssetDatabase.Refresh();

        if (allLenth == 0)
        {
            SimpleChange();
        }
        else
        {
            Debug.Log("Finish");
        }
    }


    /// <summary>
    /// Cache All Fbx Files Path
    /// 缓存所有文件路径
    /// 缓存所有文件路径
    /// </summary>
    static List<string> _cutFbxFiles = new List<string>();

    [MenuItem("Assets/多Fbx转预置(不拆解)")]
    public static void CutFbxFiles()
    {
        ////Clear All Files Path Caching
        //清空缓存
        _cutFbxFiles.Clear();

        //Select File By Mouse
        //获取通过鼠标选中的文件
        foreach (var obj in Selection.objects)
        {
            //Add to Caching
            //添加文件路径到缓存
            _cutFbxFiles.Add(AssetDatabase.GetAssetPath(obj));
        }

        // 移除重叠目录文件
        //Remove Repeat File
        for (int i = _cutFbxFiles.Count - 1; i >= 0; --i)
        {
            for (int j = 0; j < _cutFbxFiles.Count; ++j)
            {
                if (i != j && _cutFbxFiles[i].Contains(_cutFbxFiles[j]))
                {
                    _cutFbxFiles.RemoveAt(i);
                    break;
                }
            }
        }


        for (int i = _cutFbxFiles.Count - 1; i >= 0; --i)
        {
            string file = _cutFbxFiles[i];
            GameObject cloneObj = AssetDatabase.LoadAssetAtPath<GameObject>(file);
            cloneObj.name = cloneObj.name.Replace("(Clone)", string.Empty);

            string genPrefabFullName = Path.GetDirectoryName(file); ;
            genPrefabFullName = string.Concat(genPrefabFullName, "/", cloneObj.name, ".prefab");
            Object prefabObj = PrefabUtility.CreateEmptyPrefab(genPrefabFullName);
            GameObject prefab = PrefabUtility.ReplacePrefab(cloneObj, prefabObj);

            //移动资源  Moving Resources
            if (prefab != null)
            {

                _cutFbxFiles.RemoveAt(i);
                GameObject.DestroyImmediate(cloneObj, true);

            }
            else
            {
                Debug.LogError(" Change error ");
            }
        }


        //Refesh Project View
        //刷新资源视图
        AssetDatabase.Refresh();

        ////Clear All Files Path Caching
        //清空缓存
        _cutFbxFiles.Clear();


    }

}
