using UnityEngine;
using System.Collections;

public class ScreenPos : MonoBehaviour
{
    public float Speed = 1.5f;
    public float r = 0.1f;
    private float dis = -1;
    private Renderer _renderer;

    void Start ()
    {
        _renderer = GetComponent<Renderer>();
    }
	

	void Update ()
	{
	    dis += Time.deltaTime * Speed;
	    if (dis > 1){
	        dis = -1;
	    }
        _renderer.material.SetFloat("dis", dis);
        _renderer.material.SetFloat("r", r);
	}
}