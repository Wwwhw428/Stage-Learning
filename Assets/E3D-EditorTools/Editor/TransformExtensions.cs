﻿//******************************************************
//
//	文件名 (File Name) 	: 		TransformExtensions.cs
//	
//	脚本创建者(Author) 	:		微尘道人

//	创建时间 (CreatTime):		2019年8月12日 10:36
//******************************************************
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.Reflection;

/// <summary>
/// CanEditMultipleObjects---用于自定义支持多物体的编辑器
/// [CustomEditor(typeof(Transform))]---通过Editor编程扩展Transform的功能
/// </summary>
[CanEditMultipleObjects]
[CustomEditor(typeof(Transform))]
public class TransformExtensions : Editor
{
    static public TransformExtensions instance;

    SerializedProperty mPos;
    SerializedProperty mRot;
    SerializedProperty mScale;

    void OnEnable()
    {
        instance = this;

        if (this)
        {
            try
            {
                var so = serializedObject;
                mPos = so.FindProperty("m_LocalPosition");
                mRot = so.FindProperty("m_LocalRotation");
                mScale = so.FindProperty("m_LocalScale");
            }
            catch { }
        }
    }

    void OnDestroy() { instance = null; }

    /// <summary>  
    /// Draw the inspector widget.  
    /// </summary>  

    public override void OnInspectorGUI()
    {
        EditorGUIUtility.labelWidth = 15f;

        serializedObject.Update();

        DrawPosition();
        DrawRotation();
        DrawScale();

        serializedObject.ApplyModifiedProperties();
    }

    void DrawPosition()
    {
        GUILayout.BeginHorizontal();
        bool reset = GUILayout.Button("P", GUILayout.Width(20f));
        EditorGUILayout.PropertyField(mPos.FindPropertyRelative("x"));
        EditorGUILayout.PropertyField(mPos.FindPropertyRelative("y"));
        EditorGUILayout.PropertyField(mPos.FindPropertyRelative("z"));
        GUILayout.EndHorizontal();

        if (reset) mPos.vector3Value = Vector3.zero;
    }

    void DrawScale()
    {
        GUILayout.BeginHorizontal();
        {
            bool reset = GUILayout.Button("S", GUILayout.Width(20f));

            EditorGUILayout.PropertyField(mScale.FindPropertyRelative("x"));
            EditorGUILayout.PropertyField(mScale.FindPropertyRelative("y"));
            EditorGUILayout.PropertyField(mScale.FindPropertyRelative("z"));

            if (reset) mScale.vector3Value = Vector3.one;
        }
        GUILayout.EndHorizontal();
    }

    #region Rotation is ugly as hell... since there is no native support for quaternion property drawing  
    enum Axes : int
    {
        None = 0,
        X = 1,
        Y = 2,
        Z = 4,
        All = 7,
    }

    Axes CheckDifference(Transform t, Vector3 original)
    {
        Vector3 next = t.localEulerAngles;

        Axes axes = Axes.None;

        if (Differs(next.x, original.x)) axes |= Axes.X;
        if (Differs(next.y, original.y)) axes |= Axes.Y;
        if (Differs(next.z, original.z)) axes |= Axes.Z;

        return axes;
    }

    Axes CheckDifference(SerializedProperty property)
    {
        Axes axes = Axes.None;

        if (property.hasMultipleDifferentValues)
        {
            Vector3 original = property.quaternionValue.eulerAngles;

            foreach (Object obj in serializedObject.targetObjects)
            {
                axes |= CheckDifference(obj as Transform, original);
                if (axes == Axes.All) break;
            }
        }
        return axes;
    }

    /// <summary>  
    /// Draw an editable float field.  
    /// </summary>  
    /// <param name="hidden">Whether to replace the value with a dash</param>  
    /// <param name="greyedOut">Whether the value should be greyed out or not</param>  

    static bool FloatField(string name, ref float value, bool hidden, GUILayoutOption opt)
    {
        float newValue = value;
        GUI.changed = false;

        if (!hidden)
        {
            newValue = EditorGUILayout.FloatField(name, newValue, opt);
        }
        else
        {
            float.TryParse(EditorGUILayout.TextField(name, "--", opt), out newValue);
        }

        if (GUI.changed && Differs(newValue, value))
        {
            value = newValue;
            return true;
        }
        return false;
    }

    /// <summary>  
    /// Because Mathf.Approximately is too sensitive.  
    /// </summary>  

    static bool Differs(float a, float b) { return Mathf.Abs(a - b) > 0.0001f; }

    static public void RegisterUndo(string name, params Object[] objects)
    {
        if (objects != null && objects.Length > 0)
        {
            UnityEditor.Undo.RecordObjects(objects, name);

            foreach (Object obj in objects)
            {
                if (obj == null) continue;
                EditorUtility.SetDirty(obj);
            }
        }
    }

    static public float WrapAngle(float angle)
    {
        while (angle > 180f) angle -= 360f;
        while (angle < -180f) angle += 360f;
        return angle;
    }

    void DrawRotation()
    {
        GUILayout.BeginHorizontal();
        {
            bool reset = GUILayout.Button("R", GUILayout.Width(20f));

            Vector3 visible = (serializedObject.targetObject as Transform).localEulerAngles;

            visible.x = WrapAngle(visible.x);
            visible.y = WrapAngle(visible.y);
            visible.z = WrapAngle(visible.z);

            Axes changed = CheckDifference(mRot);
            Axes altered = Axes.None;

            GUILayoutOption opt = GUILayout.MinWidth(30f);

            if (FloatField("X", ref visible.x, (changed & Axes.X) != 0, opt)) altered |= Axes.X;
            if (FloatField("Y", ref visible.y, (changed & Axes.Y) != 0, opt)) altered |= Axes.Y;
            if (FloatField("Z", ref visible.z, (changed & Axes.Z) != 0, opt)) altered |= Axes.Z;

            if (reset)
            {
                mRot.quaternionValue = Quaternion.identity;
            }
            else if (altered != Axes.None)
            {
                RegisterUndo("Change Rotation", serializedObject.targetObjects);

                //多选游戏对象
                foreach (Object obj in serializedObject.targetObjects)
                {
                    Transform t = obj as Transform;
                    Vector3 v = t.localEulerAngles;

                    if ((altered & Axes.X) != 0) v.x = visible.x;
                    if ((altered & Axes.Y) != 0) v.y = visible.y;
                    if ((altered & Axes.Z) != 0) v.z = visible.z;

                    t.localEulerAngles = v;
                }
            }
        }
        GUILayout.EndHorizontal();
    }
    #endregion
}
