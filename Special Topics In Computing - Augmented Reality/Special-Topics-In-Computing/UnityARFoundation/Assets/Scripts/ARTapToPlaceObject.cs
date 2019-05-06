using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.ARFoundation;
using UnityEngine.Experimental.XR;
using System;

public class ARTapToPlaceObject : MonoBehaviour
{
    private ARSessionOrigin arOrigin;
    //pose describes position and rotation of a 3d point
    private Pose placementPose;
    // we only consider this true if hits array has one item in it
    private bool placementPoseIsValid = false;
    private bool placed = false;
    public GameObject placementIndicator;
    public GameObject objectToPlace;

    void Start()
    {
        // Save reference to arOrigin on start
        arOrigin = FindObjectOfType<ARSessionOrigin>();
    }

    void Update()
    {
        // this script is done when we place the indicator
        if (placed) return;
        // We want to find out where the camera is pointing and find out if there
        // is a position in virtual space that we can place an object
        UpdatePlacementPose();
        UpdatePlacementIndicator();

        if(placementPoseIsValid && Input.touchCount > 0 && Input.GetTouch(0).phase == TouchPhase.Began)
        {
            PlaceObject();
            placed = true;
            placementIndicator.SetActive(false);
        }
    }

    private void PlaceObject()
    {
        GameObject portal = Instantiate(objectToPlace, placementPose.position, placementPose.rotation);
        PlayerController playerController = FindObjectOfType<PlayerController>();
        playerController.SetPortalsParent(portal);

        // disable placement indicator
    }

    private void UpdatePlacementPose()
    {
        // AR Version of raycast but we're checking against REAL world surfaces
        // We need to get the screen center to send raycast from
        Vector3 screenScenter = Camera.current.ViewportToScreenPoint(new Vector3(0.5f, 0.5f, 0));
        List<ARRaycastHit> hits = new List<ARRaycastHit>();
        arOrigin.Raycast(screenScenter, hits, TrackableType.Planes);
        placementPoseIsValid = hits.Count > 0;
        if (placementPoseIsValid)
        {
            placementPose = hits[0].pose;

            Vector3 cameraForward = Camera.current.transform.forward;
            Vector3 cameraBearing = new Vector3(cameraForward.x, 0, cameraForward.z).normalized;

            placementPose.rotation = Quaternion.LookRotation(cameraBearing);
        }
    }

    private void UpdatePlacementIndicator() {
        if (placementPoseIsValid)
        {
            placementIndicator.SetActive(true);
            placementIndicator.transform.SetPositionAndRotation(placementPose.position, placementPose.rotation);
        }
        else
        {
            placementIndicator.SetActive(false);
        }
    }

}
