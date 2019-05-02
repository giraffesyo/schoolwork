using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SendToStart : MonoBehaviour
{
    public GameObject startingPoint;

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            Rigidbody rb = other.gameObject.GetComponent<Rigidbody>();
            rb.MovePosition(startingPoint.transform.position);
        }
    }
}
