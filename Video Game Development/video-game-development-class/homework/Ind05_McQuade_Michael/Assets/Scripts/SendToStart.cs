using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SendToStart : MonoBehaviour
{

        public void SendHome()
        {
            Rigidbody rb = GetComponent<Rigidbody>();

            rb.transform.localPosition = (Vector3.zero);
            rb.velocity = Vector3.zero;
            rb.angularVelocity = Vector3.zero;
        }
    }
