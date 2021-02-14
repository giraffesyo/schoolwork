using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public abstract class SliderBase : MonoBehaviour
{

    private Slider slider;
    private float previousValue;
    void Start()
    {
        slider = GetComponent<Slider>();

        slider.onValueChanged.AddListener(OnSliderChanged);
        // initialize previousValue
        previousValue = this.slider.value;
    }

    private void _OnSliderChanged(float newValue)
    {
        float change = newValue - this.previousValue;
        this.previousValue = newValue;
        this.OnSliderChanged(change);
    }

    public abstract void OnSliderChanged(float delta);
}
