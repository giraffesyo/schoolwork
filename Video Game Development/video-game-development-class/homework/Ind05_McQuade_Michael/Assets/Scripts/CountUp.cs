using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class CountUp : MonoBehaviour
{

    public Text counter;
    public float playtime;
    // Start is called before the first frame update
    void Start()
    {
        playtime = 0;
    }

    // Update is called once per frame
    void Update()
    {
        playtime += Time.deltaTime;
        UpdateCounter();
    }

    private void UpdateCounter()
    {
        int minutes = Mathf.FloorToInt(playtime / 60);
        int seconds = Mathf.FloorToInt(playtime % 60);
        string secondsString = seconds > 9 ? seconds.ToString() : $"0{seconds}";
        string minutesString = minutes > 9 ? minutes.ToString() : $"0{minutes}";
        counter.text = minutesString + ":" + secondsString;
    }
}
