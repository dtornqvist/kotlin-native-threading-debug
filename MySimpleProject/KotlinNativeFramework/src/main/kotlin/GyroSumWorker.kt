import kotlin.native.concurrent.*

class GyroSumWorker {

    var listener: GyroSumWorkerListener? = null
    private val gyroSumComputer = GyroSumComputer()
    private val worker = Worker.start()

    fun performOperation(input: InputData) {
        input.freeze()
        // I cannot freeze gyroSumComputer as it may contain buffers and states that changes over time. How to solve this?
        worker.execute(TransferMode.SAFE, { Pair(gyroSumComputer, input) }) { input ->
            input.first?.performOperation(input.second)
        }.consume { outputData ->
            listener?.gyroSumUpdate(outputData)
        }
    }
}

interface GyroSumWorkerListener {
    fun gyroSumUpdate(outputData: OutputData)
}
