using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class RotationSlider : MonoBehaviour
{
    private Slider slider;
    public GameObject gameobjectToRotate;
    // Start is called before the first frame update
    private float previousValue;

    void Start()
    {
        slider = GetComponent<Slider>();

        slider.onValueChanged.AddListener(OnSliderChanged);
        // initialize previousValue
        previousValue = this.slider.value;
    }

    void OnSliderChanged(float newValue)
    {
        float change = newValue - this.previousValue;
        this.gameobjectToRotate.transform.Rotate(Vector3.right * change * 360);
        this.previousValue = newValue;
    }
}
