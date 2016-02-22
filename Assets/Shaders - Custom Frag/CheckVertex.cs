using UnityEngine;
using System.Collections;
using System.Linq;

// 检测一个面片的范围
public class CheckVertex : MonoBehaviour {

	public MeshFilter Mesh;
	
	void Start () {
		if (!Mesh) {
			Mesh = GetComponent<MeshFilter>();
		}
        
        if (Mesh){
            float max, min;
            Vector3[] verts = Mesh.mesh.vertices;
            
            max = verts.Max(v => v.x);
            min = verts.Min(v => v.x);
            print("X:  Max: " + max + " |  min: " + min);
            
            max = verts.Max(v => v.y);
            min = verts.Min(v => v.y);
            print("Y:  Max: " + max + " |  min: " + min); 
            
            max = verts.Max(v => v.z);
            min = verts.Min(v => v.z);
            print("Z:  Max: " + max + " |  min: " + min); 
        }
	}
	
}
