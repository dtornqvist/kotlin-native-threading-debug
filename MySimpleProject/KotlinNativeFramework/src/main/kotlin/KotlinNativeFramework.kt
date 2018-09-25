//
//  KotlinNativeFramework.kt
//  KotlinNativeFramework
//

class KotlinNativeFramework {

    private var currentOutput = OutputData(0.0)

    fun performOperation(input: InputData): OutputData {
        currentOutput = OutputData(currentOutput.xSum + input.x)
        return currentOutput
    }
}

data class OutputData(val xSum: Double)

data class InputData(val x: Double)