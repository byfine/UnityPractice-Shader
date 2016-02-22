using UnityEngine;
using System.Collections;

public class MVPTransform : MonoBehaviour {

	
    Renderer _renderer;
    
	void Start () {
	   _renderer = GetComponent<Renderer>();      
	}
	

	void Update () {
        // 构造MVP矩阵
        Matrix4x4 mvp = Camera.main.projectionMatrix * Camera.main.worldToCameraMatrix * transform.localToWorldMatrix;

        // 构造绕Y轴旋转矩阵
        Matrix4x4 rotMatrix = new Matrix4x4();
	    rotMatrix[0, 0] = Mathf.Cos(Time.timeSinceLevelLoad);
	    rotMatrix[0, 2] = Mathf.Sin(Time.timeSinceLevelLoad);
	    rotMatrix[1, 1] = 1;
	    rotMatrix[2, 0] = -Mathf.Sin(Time.timeSinceLevelLoad);
	    rotMatrix[2, 2] = Mathf.Cos(Time.timeSinceLevelLoad);
        rotMatrix[3, 3] = 1;

        // 构造缩放矩阵
        Matrix4x4 scaleMatrix = new Matrix4x4();
	    scaleMatrix[0, 0] = Mathf.Sin(Time.timeSinceLevelLoad) / 4f + 0.5f;
	    scaleMatrix[1, 1] = Mathf.Cos(Time.timeSinceLevelLoad) / 8f + 0.5f;
        scaleMatrix[2, 2] = Mathf.Sin(Time.timeSinceLevelLoad) / 4f + 0.5f;
        scaleMatrix[3, 3] = 1;

        // 向shader传递矩阵
        _renderer.material.SetMatrix("mvp", mvp);
        _renderer.material.SetMatrix("rotMatrix", rotMatrix);
        _renderer.material.SetMatrix("scaleMatrix", scaleMatrix);
	}
}
