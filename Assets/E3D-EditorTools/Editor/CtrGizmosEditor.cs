//******************************************************
//
//	文件名 (File Name) 	: 		CtrGizmosEditor.cs
//	
//	脚本创建者(Author) 	:		微尘道人

//	创建时间 (CreatTime):		2019年8月12日 18:20
//******************************************************

using System;
using System.Collections;
using System.Reflection;
using UnityEditor;

 /// <summary>
    /// 全局控制gizmos显示或者关闭
    /// </summary>
public class CtrGizmosEditor
{
    private static bool _globalGizmosOn;

    /*
 *  # 代表 shift  

    & 代表  alt

    % 代表 Ctrl

 */
    [MenuItem("E3D-EditorTools/Scene View/Toggle Gizmos &%P")]
    private static void ToggleAllSceneGizmos()
    {
        _globalGizmosOn = !_globalGizmosOn;
        ToggleGizmos(_globalGizmosOn);
    }

    [MenuItem("E3D-EditorTools/Scene View/关闭所有显示Gizmos &T")]
    private static void DisableAllSceneGizmos()
    {
        _globalGizmosOn = false;
        ToggleGizmos(_globalGizmosOn);
    }

    [MenuItem("E3D-EditorTools/Scene View/开启所有显示Gizmos &P")]
    private static void EnableAllSceneGizmos()
    {
        _globalGizmosOn = true;
        ToggleGizmos(_globalGizmosOn);
    }

    private static void ToggleGizmos(bool gizmosOn)
    {
        int val = gizmosOn ? 1 : 0;
        Assembly asm = Assembly.GetAssembly(typeof(Editor));
        Type type = asm.GetType("UnityEditor.AnnotationUtility");
        if (type != null)
        {
            MethodInfo getAnnotations = type.GetMethod("GetAnnotations", BindingFlags.Static | BindingFlags.NonPublic);
            MethodInfo setGizmoEnabled = type.GetMethod("SetGizmoEnabled", BindingFlags.Static | BindingFlags.NonPublic);
            MethodInfo setIconEnabled = type.GetMethod("SetIconEnabled", BindingFlags.Static | BindingFlags.NonPublic);
            var annotations = getAnnotations.Invoke(null, null);
            foreach (object annotation in (IEnumerable)annotations)
            {
                Type annotationType = annotation.GetType();
                FieldInfo classIdField = annotationType.GetField("classID", BindingFlags.Public | BindingFlags.Instance);
                FieldInfo scriptClassField = annotationType.GetField("scriptClass", BindingFlags.Public | BindingFlags.Instance);
                if (classIdField != null && scriptClassField != null)
                {
                    int classId = (int)classIdField.GetValue(annotation);
                    string scriptClass = (string)scriptClassField.GetValue(annotation);
                    setGizmoEnabled.Invoke(null, new object[] { classId, scriptClass, val });
                    setIconEnabled.Invoke(null, new object[] { classId, scriptClass, val });
                }
            }
        }
    }
}
