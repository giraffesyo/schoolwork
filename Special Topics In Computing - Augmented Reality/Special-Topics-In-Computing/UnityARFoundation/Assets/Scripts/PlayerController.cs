using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class PlayerController : MonoBehaviour
{

    public Material[] materials;

    void Start()
    {
        MakeInvisible();
    }


    private void MakeInvisible()
    {
        foreach (var mat in materials)
        {
            mat.SetInt("_StencilTest", (int)CompareFunction.Equal);
        }
    }

    private void MakeVisible()
    {
        foreach (var mat in materials)
        {
            mat.SetInt("_StencilTest", (int)CompareFunction.NotEqual);
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if(other.tag != "MainCamera") {
            return;
          }

        // Outside of portal is "equls"
        // Inside of portal is "not equals"
        if(transform.position.z > other.transform.position.z)
        {
            MakeInvisible();
        }
        else
        {// inside portal
            MakeVisible();
        }
    }

    // Since we're dealing with shader materials these aren't reset on play mode enter/exit
    // so we need to reset them
    private void OnDestroy()
    {
        MakeVisible();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
