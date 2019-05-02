using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SendToStart : MonoBehaviour
{
    public GameObject startingPoint;

        public void SendHome()
        {
            Rigidbody rb = GetComponent<Rigidbody>();
            rb.MovePosition(startingPoint.transform.position);
            rb.velocity = Vector3.zero;
            rb.angularVelocity = Vector3.zero;
        }
    }
