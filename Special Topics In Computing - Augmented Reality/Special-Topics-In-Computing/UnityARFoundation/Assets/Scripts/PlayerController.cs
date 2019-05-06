using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class PlayerController : MonoBehaviour
{

public Transform device;
    private GameObject portalsParent;
    private bool portalPlaced;
    private bool insidePortal;
    private GameObject currentPortal;
    private GameObject otherPortal;
    private GameObject portal1;
    private GameObject portal2;
    public bool testing;
    //private GameObject portalWindow;

    private bool wasInFront = false;

    private bool isColliding;

    void Start()
    {
        SetRender(false);
        if(testing) {
            GameObject portalsparent = GameObject.FindWithTag("PortalParent");
            SetPortalsParent(portalsParent);
        }
    }


    public void SetPortalsParent(GameObject portalsParent) {
        this.portalsParent = portalsParent;
        portalPlaced = true;
        currentPortal = GameObject.FindWithTag("Portal1");
        otherPortal = GameObject.FindWithTag("Portal2");
        //portalWindow = GameObject.FindWithTag("PortalWindow");
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

    void WhileCameraColliding()
    {

        bool isInFront = CheckInFront();

        if (isColliding)
        {
            if ((isInFront && !wasInFront) || (wasInFront && !isInFront))
            {
                insidePortal = !insidePortal;
                SetRender(insidePortal);
            }
        }
        else
        {
            if (!insidePortal && ((isInFront && !wasInFront) || (wasInFront && !isInFront)))
            {
                var tempPortal = currentPortal;
                currentPortal = otherPortal;
                otherPortal = tempPortal;
                currentPortal.SetActive(true);
                otherPortal.SetActive(false);
            }
        }
        wasInFront = isInFront;

    }

    bool CheckInFront()
    {
        Vector3 worldPos = device.position + device.forward * Camera.main.nearClipPlane;

        Vector3 pos = transform.InverseTransformPoint(worldPos);
        return pos.z >= 0;
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.transform != device)
            return;
        wasInFront = CheckInFront();
        isColliding = true;
    }

    void OnTriggerExit(Collider other)
    {
        if (other.transform != device)
            return;
        isColliding = false;
    }
    void Update()
    {
        WhileCameraColliding();
    }

    private void OnDestroy()
    {
        SetRender(true);
    }
}

