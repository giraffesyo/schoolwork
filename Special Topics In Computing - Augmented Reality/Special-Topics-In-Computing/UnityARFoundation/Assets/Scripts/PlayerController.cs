using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class PlayerController : MonoBehaviour
{

public Transform device;

    void Start()
    {
        SetRender(false);
    }

    void SetRender(bool render)
    {
        // Outside of portal is "equls"
        // Inside of portal is "not equals"
        var StencilTest = render ? CompareFunction.NotEqual : CompareFunction.Equal;
        Shader.SetGlobalInt("_StencilTest", (int)StencilTest);
    }

    private void OnTriggerStay(Collider other)
    {
        if(other.tag != "MainCamera") {
            return;
          }


        if(transform.position.z > other.transform.position.z)
        {
            SetRender(false);
        }
        else
        {// inside portal
            SetRender(true);
        }
    }

    private void OnDestroy()
    {
        SetRender(false);
    }
}

