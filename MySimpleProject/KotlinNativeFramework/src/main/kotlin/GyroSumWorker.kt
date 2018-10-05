import kotlin.native.concurrent.*


@ThreadLocal
private var gyroSumComputer: GyroSumComputer? = null

class GyroSumWorker {
    var listener: GyroSumWorkerListener? = null
    private val worker = Worker.start()

    init {
        worker.execute(TransferMode.SAFE, { GyroSumComputer() }) {
            gyroSumComputer = it
        }
    }

    fun performOperation(input: InputData) {
        println("input data received")
        input.freeze()
        worker.execute(TransferMode.UNSAFE, { Pair(input, listener) }) { (input, listener) ->
            val result = gyroSumComputer?.performOperation(input)
            result?.let { listener?.gyroSumUpdate(it) }
        }
    }
}

interface GyroSumWorkerListener {
    fun gyroSumUpdate(outputData: OutputData)
}
