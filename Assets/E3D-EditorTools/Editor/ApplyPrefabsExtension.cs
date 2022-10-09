
using System.Text;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class ApplyPrefabsExtension : Editor
{
    [MenuItem("GameObject/多应用修改的预置", false, 12)]
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
