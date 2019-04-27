using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour
{
    public float speed = 0.0f;
    public string axis = "Y";
    private Transform transform;

    void Start()
    {
        transform = GetComponent<Transform>();
    }

    void Update()
    {
        switch(axis)
        {
            case "X":
                transform.Rotate(speed, 0, 0);
                break;
            case "Y":
                transform.Rotate(0, speed, 0);
                break;
            case "Z":
                transform.Rotate(0, 0, speed);
                break;
            default:
                break;
        }

    }
}
