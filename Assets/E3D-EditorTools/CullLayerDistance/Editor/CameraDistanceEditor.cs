using UnityEngine;
using UnityEditor;

namespace BnH {
	[CustomEditor(typeof(CameraDistance))]
	public class CameraDistanceEditor : Editor {
		public override void OnInspectorGUI() {
			base.OnInspectorGUI();

			CameraDistance self = (CameraDistance)target;

			for (int i = 0; i < 32; ++i) {
				string layerName = LayerMask.LayerToName(i);
				if (layerName.Length > 0) {
					float distance = 0;
					for (int j = 0; j < self.cullDistances.Count; ++j) {
						CameraLayerInfo info  = self.cullDistances[j];
						if (info.layer == i) {
							distance = info.distance;
						}
					}

					EditorGUI.BeginChangeCheck();
					distance = EditorGUILayout.FloatField(layerName, distance);
					if (EditorGUI.EndChangeCheck()) {
						self.SetDistance(i, distance);
					}
				}
			}

			serializedObject.ApplyModifiedProperties();

			if (GUI.changed) {
				EditorUtility.SetDirty(self);
			}
		}
	}
}
