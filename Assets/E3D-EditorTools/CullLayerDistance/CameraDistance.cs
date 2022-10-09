using UnityEngine;
using System.Collections.Generic;

namespace BnH {
	[System.Serializable]
	public class CameraLayerInfo {
		public int layer;
		public float distance;
		public CameraLayerInfo(int l, float d) {
			layer = l;
			distance = d;
		}
	}; 

	public class CameraDistance : MonoBehaviour {
		// public Dictionary<int, float> cullDistances = new Dictionary<int, float>();
		public List<CameraLayerInfo> cullDistances = new List<CameraLayerInfo>();
		private Camera _camera;

		void Awake() {
		}

		void Start() {
			_camera = GetComponent<Camera>();
			UpdateDistances();
		}

		void UpdateDistances() {
			float[] distances = new float[32];
			for (int i = 0; i < cullDistances.Count; ++i) {
				CameraLayerInfo info = cullDistances[i];
				if (info.distance > 0) {
					distances[info.layer] = info.distance;
				}
			}

			if (_camera) {
				_camera.layerCullDistances = distances;
			}
		}

		public void SetDistance(int layer, float distance) {
			if (distance < 0) {
				return ;
			}

			bool hasValue = false;
			for (int i = 0; i < cullDistances.Count; ++i) {
				CameraLayerInfo info = cullDistances[i];
				if (info.layer == layer) {
					info.distance = distance;
					hasValue = true;
					break;
				}
			}
			if (!hasValue) {
				cullDistances.Add(new CameraLayerInfo(layer, distance));
			}
			UpdateDistances();
		}
	}
}
