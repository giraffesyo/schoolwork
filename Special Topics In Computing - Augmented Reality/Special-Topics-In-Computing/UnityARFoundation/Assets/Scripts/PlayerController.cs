using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class PlayerController : MonoBehaviour
{

public Transform device;
    public GameObject portalsParent;
    private bool portalPlaced = false;
    private bool insidePortal = false;
    private GameObject currentPortal;
    private GameObject otherPortal;
    private GameObject portal1;
    private GameObject portal2;

    void Start()
    {
        SetRender(false);
    }


    public void SetPortalsParent(GameObject portalsParent) {
        this.portalsParent = portalsParent;
        portalPlaced = true;
        currentPortal = GameObject.FindWithTag("Portal1");
        otherPortal = GameObject.FindWithTag("Portal2");
        otherPortal.SetActive(false);
         portal1 = currentPortal;
        portal2 = otherPortal;

    }

    void SetRender(bool render)
    {
        // Outside of portal is "equls"
        // Inside of portal is "not equals"
        var StencilTest = render ? CompareFunction.NotEqual : CompareFunction.Equal;
        Shader.SetGlobalInt("_StencilTest", (int)StencilTest);
    }

    private void Update()
    {
        if (!insidePortal)
        {
            if (device.transform.position.z > portalsParent.transform.position.z)
            {
                currentPortal = portal2;
                otherPortal = portal1;
                portal2.SetActive(true);
                portal1.SetActive(false);
            }
            else
            {
                currentPortal = portal1;
                otherPortal = portal2;
                portal1.SetActive(true);
                portal2.SetActive(false);
            }
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if(other.tag != "MainCamera") {
            return;
          }


        if(transform.position.z > other.transform.position.z)
        {
            SetRender(false);
            insidePortal = false;
        }
        else
        {// inside portal
            SetRender(true);
            insidePortal = true;
        }
    }

    private void OnDestroy()
    {
        SetRender(false);
    }
}

