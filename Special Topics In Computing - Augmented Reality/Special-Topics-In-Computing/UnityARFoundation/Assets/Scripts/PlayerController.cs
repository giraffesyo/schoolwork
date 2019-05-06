using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class PlayerController : MonoBehaviour
{

public Transform device;
    public GameObject portalsParent;
    private bool portalPlaced;
    private bool insidePortal;
    private GameObject currentPortal;
    private GameObject otherPortal;
    private GameObject portal1;
    private GameObject portal2;
    public bool testing;

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
        otherPortal.SetActive(false);
         portal1 = currentPortal;
        portal2 = otherPortal;

    }

//    bool CheckInFront()
//    {
//        Vector3 pos = transform.InverseTransformPoint(device.position);
//        bool inFront = pos.z >= 0;
////        Debug.Log("Is in front:" + inFront);
    //    return inFront;
    //}

    void SetRender(bool render)
    {
        // Outside of portal is "equls"
        // Inside of portal is "not equals"
        var StencilTest = render ? CompareFunction.NotEqual : CompareFunction.Equal;
        Shader.SetGlobalInt("_StencilTest", (int)StencilTest);
    }

    //private void Update()
    //{
    //    if (portalPlaced)
    //    {
    //        if (!insidePortal && ((isInFront && !wasInFront) || (wasInFront && !isInFront)))
    //        {
    //            var tempPortal = currentPortal;
    //            currentPortal = otherPortal;
    //            otherPortal = tempPortal;
    //            currentPortal.SetActive(true);
    //            otherPortal.SetActive(false);
    //        }
    //    }
    //}

    //private void OnTriggerEnter(Collider other)
    //{
    //    if (other.transform != device)
    //    {
    //      //  Debug.Log("other.transform was not device");
    //        return;
    //    }

    //    wasInFront = CheckInFront();
    //    //Debug.Log("Trigger entered was in front set to: ," + wasInFront);
    //}

    //private void OnTriggerStay(Collider other)
    //{
    //    if (other.transform != device) {
    //        //Debug.Log("other.transform was not device");
    //        return; 
    //    }
    //    isInFront = CheckInFront();
    //    Debug.Log($"Is in front {isInFront}");

    //    if((isInFront && !wasInFront) || (wasInFront && !isInFront))
    //    {
    //        insidePortal = !insidePortal;
    //        SetRender(insidePortal);
    //        Debug.Log("Flipping set render");
    //    }
    //}


    // begin other code


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

