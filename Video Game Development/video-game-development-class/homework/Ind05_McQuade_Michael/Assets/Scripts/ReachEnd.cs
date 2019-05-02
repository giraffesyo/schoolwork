using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ReachEnd : MonoBehaviour
{

    public VictoryCheck victoryCheck;
    private void OnTriggerEnter(Collider other)
    {
        if(other.tag == "Player") {
            Destroy(other);
            victoryCheck.Goal();
        }

    }
}
