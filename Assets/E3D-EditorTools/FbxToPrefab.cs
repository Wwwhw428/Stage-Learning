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
    private static string prefabDirectory = "/Prefab";
    private static string prefabExtension = ".prefab";

    [MenuItem("Assets/Fbx转预置(不拆解)")]
    public static void SimpleChange()
    {
        GameObject selectedGameObject = Selection.activeGameObject;
        string selectedAssetPath = AssetDatabase.GetAssetPath(selectedGameObject);
        if (string.IsNullOrEmpty(selectedAssetPath))
        {
            return;
        }

        string modelAssetPath = string.Concat(Application.dataPath, prefabDirectory);
        string modelParentPath = string.Concat("Assets/Resources", prefabDirectory);
        string modelFullPath = string.Concat(modelParentPath, "/", "Model");
        if (!Directory.Exists(modelFullPath))
        {
            Directory.CreateDirectory(Application.dataPath + "/Resources/Prefab/Model");
        }
        if (Directory.Exists(modelFullPath))
        {
            GameObject cloneObj = GameObject.Instantiate<GameObject>(selectedGameObject);
            cloneObj.name = cloneObj.name.Replace("(Clone)", string.Empty);
            string genPrefabFullName = string.Concat(modelFullPath, "/", cloneObj.name, prefabExtension);

            Object prefabObj = PrefabUtility.CreateEmptyPrefab(genPrefabFullName);
            GameObject prefab = PrefabUtility.ReplacePrefab(cloneObj, prefabObj);
            GameObject.DestroyImmediate(cloneObj);
        }

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

    [MenuItem("GameObject/Tool/批量应用修改的预置")]
    static void ApplySelectedPrefabs()
    {
        //获取选中的gameobject对象  
        GameObject[] selectedsGameobject = Selection.gameObjects;
        GameObject prefab = PrefabUtility.FindPrefabRoot(selectedsGameobject[0]);
        List<GameObject> _prefabObjs = new List<GameObject>();
        int _max = 0;
        float _current = 0;
        for (int i = 0; i < selectedsGameobject.Length; i++)
        {
            _max++;
        }
        for (int j = 0; j < selectedsGameobject.Length; j++)
        {
            //判断选择的物体，是否为预设  
            if (PrefabUtility.GetPrefabType(selectedsGameobject[j]) != PrefabType.PrefabInstance)
            {
                continue;
            }
            else
            {
                if (!_prefabObjs.Contains(selectedsGameobject[j]))
                {
                    _prefabObjs.Add(selectedsGameobject[j]);
                }
            }
        }

        for (int i = 0; i < _prefabObjs.Count; i++)
        {
            string jindu = string.Format("正在生成，请耐心等待，当前进度:{0}%", ((_current / _max) * 100).ToString("0.00"));

            UnityEngine.Object parentObject = PrefabUtility.GetPrefabParent(_prefabObjs[i]);
            PrefabUtility.ReplacePrefab(_prefabObjs[i], parentObject, ReplacePrefabOptions.ConnectToPrefab);
            EditorUtility.DisplayProgressBar("Apply应用进度条", jindu, _current / _max);
            _current++;
        }
        EditorUtility.ClearProgressBar();
        //刷新  
        AssetDatabase.Refresh();
        Debug.Log("操作完成");
    }

}
