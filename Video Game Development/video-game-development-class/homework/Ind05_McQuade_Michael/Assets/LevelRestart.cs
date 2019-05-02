using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelRestart : MonoBehaviour
{
    public SendToStart[] spheres;
    public CountUp timer;
    public GameObject gameboard;

    public void Restart()
    {

        timer.playtime = 0;
        //Rigidbody gbrb = gameboard.GetComponent<Rigidbody>();
        //gbrb.transform.localRotation = Quaternion.identity;
        foreach (SendToStart sphere in spheres)
        {
            sphere.SendHome();
        }
    }
}
