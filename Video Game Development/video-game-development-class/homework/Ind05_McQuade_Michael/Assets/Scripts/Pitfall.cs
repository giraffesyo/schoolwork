using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pitfall : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        if(other.tag == "Player")
        {
            SendToStart sendToStartScript = other.GetComponent<SendToStart>();
            sendToStartScript.SendHome();
        }
    }

}
