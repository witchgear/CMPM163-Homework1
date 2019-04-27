using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Translate : MonoBehaviour
{
    public float lowerBounds = 0.0f;
    public float upperBounds = 100.0f;
    public float speed = 10.0f;
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
                // if object moves out of bounds, flip direction
                if(transform.position.x > upperBounds || transform.position.x < lowerBounds)
                {
                    speed *= -1;
                }
                transform.Translate(speed, 0, 0);
                break;
            case "Y":
                // if object moves out of bounds, flip direction
                if(transform.position.y > upperBounds || transform.position.y < lowerBounds)
                {
                    speed *= -1;
                }
                transform.Translate(0, speed, 0);
                break;
            case "Z":
                // if object moves out of bounds, flip direction
                if(transform.position.z > upperBounds || transform.position.z < lowerBounds)
                {
                    speed *= -1;
                }
                transform.Translate(0, 0, speed);
                break;
            case "Dog": // dog needs to move on all axes to just go one direction for some reason
                if(transform.position.y > upperBounds || transform.position.y < lowerBounds)
                {
                    speed *= -1;
                }
                transform.Translate(speed * (4.0f/3.0f), speed, speed * (26.0f/3.0f));
                break;
            default:
                break;
        }
    }
}
