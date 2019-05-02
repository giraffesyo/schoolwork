using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelRestart : MonoBehaviour
{
    public Transform[] spawnPoints;
    public CountUp timer;
    public GameObject gameboard;
    public GameObject PlayerSpherePrefab;


    public void Restart()
    {

        timer.playtime = 0;
        Rigidbody gbrb = gameboard.GetComponent<Rigidbody>();
        gbrb.transform.localRotation = Quaternion.identity;
        foreach(Transform spawnpoint in spawnPoints) {
            GameObject newSphere = Instantiate(PlayerSpherePrefab, spawnpoint);
            SendToStart sendHomeScript = newSphere.GetComponent<SendToStart>();
            if(sendHomeScript != null) {
                sendHomeScript.SendHome();
            }

        }

    }
    }

