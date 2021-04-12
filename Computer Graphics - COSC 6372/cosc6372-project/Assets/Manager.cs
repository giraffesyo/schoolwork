using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Manager : MonoBehaviour
{
    // Start is called before the first frame update
    public Transform rightHand;
    [SerializeField]
    private float RightHandYPosition;
    void Start()
    {
        UpdateRightHandPosition();
    }

    // Update is called once per frame
    void Update()
    {
        UpdateRightHandPosition();
    }

    void UpdateRightHandPosition()
    {
        RightHandYPosition = rightHand.position.y;
    }
}
