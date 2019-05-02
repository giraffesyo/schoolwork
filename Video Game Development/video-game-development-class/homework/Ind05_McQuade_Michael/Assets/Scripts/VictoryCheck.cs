using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VictoryCheck : MonoBehaviour
{
    public int points = 0;
    public Menu menu;
    // Update is called once per frame
    void Update()
    {
        if(points == 3) {
            GameOver();
        }

    }

    private void GameOver()
    {
        menu.GameOver();
        points = 0;
    }

    public void Goal()
    {
        points++;
    }
}
