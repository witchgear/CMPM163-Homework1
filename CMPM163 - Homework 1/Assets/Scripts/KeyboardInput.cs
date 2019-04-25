using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class KeyboardInput : MonoBehaviour
{
   private Renderer render;
   private float steps = 0.0f;
   public float increment = 1.0f;

   void Start()
   {
      // Get this object's renderer and associate it with the proper shader
      render = GetComponent<Renderer>();
      render.material.shader = Shader.Find("Custom/Blur");
   }

   void Update()
   {
      // increase steps if up arrow is pressed
      if(Input.GetKey("up"))
      {
         steps += increment;
      }
      // decrease steps if down arrow is pressed
      else if(Input.GetKey("down") && steps > 0.0f)
      {
         steps -= increment;
      }

      // update shader variable to value set by input
      render.material.SetFloat("_Steps", steps);
   }
}
