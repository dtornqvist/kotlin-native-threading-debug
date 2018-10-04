import kotlin.native.concurrent.*


@ThreadLocal
private var gyroSumComputer: GyroSumComputer? = null

class GyroSumWorker {
    var listener: GyroSumWorkerListener? = null
    private val worker = Worker.start()
    private val listenerWorker = Worker.start()

    init {
        worker.execute(TransferMode.SAFE, { GyroSumComputer() }) {
            gyroSumComputer = it
        }
    }

    fun performOperation(input: InputData) {
        println("input data received")
        input.freeze()
        val future = worker.execute(TransferMode.SAFE, { input }) {
            gyroSumComputer?.performOperation(it)
        }

        listenerWorker.execute(TransferMode.SAFE, { Pair(future, listener.freeze()) }) { input ->
            input.first.consume { outputData ->
                println("output computed")
                outputData?.let { input.second?.gyroSumUpdate(it) }
            }
        }
    }
}

interface GyroSumWorkerListener {
    fun gyroSumUpdate(outputData: OutputData)
}
