using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SendToSpawn : MonoBehaviour
{
    public Transform spawnPoint;
    // Start is called before the first frame update

    private void OnTriggerEnter(Collider other)
    {
        other.gameObject.transform.position = spawnPoint.position;
        Rigidbody otherRb = other.gameObject.GetComponent<Rigidbody>();
        otherRb.angularVelocity = new Vector3(0, 0, 0);
        otherRb.velocity = new Vector3(0, 0, 0);
    }
}
