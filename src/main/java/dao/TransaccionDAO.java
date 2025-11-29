package dao;

import conexion.Conexion;
import entity.Transaccion;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class TransaccionDAO {
    
    public List<Transaccion> getTransacciones() {
        Conexion conn = new Conexion();
        Connection conexion = null;
        List<Transaccion> transacciones = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conexion = conn.getConexion();
            String query = "SELECT * FROM tablas.transaccion ORDER BY id_transaccion ASC";
            ps = conexion.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Transaccion transaccion = new Transaccion(
                    rs.getInt("id_transaccion"),
                    rs.getTimestamp("fecha_hora").toLocalDateTime(),
                    rs.getBigDecimal("total"),
                    rs.getString("metodo_pago")
                );
                transacciones.add(transaccion);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
        return transacciones;
    }
    
    public Transaccion getTransaccionPorId(int idTransaccion) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        Transaccion transaccion = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conexion = conn.getConexion();
            String query = "SELECT * FROM tablas.transaccion WHERE id_transaccion = ?";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, idTransaccion);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                transaccion = new Transaccion(
                    rs.getInt("id_transaccion"),
                    rs.getTimestamp("fecha_hora").toLocalDateTime(),
                    rs.getBigDecimal("total"),
                    rs.getString("metodo_pago")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
        return transaccion;
    }
    
    public void insertarTransaccion(Transaccion transaccion) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        PreparedStatement ps = null;
        
        try {
            conexion = conn.getConexion();
            String query = "INSERT INTO tablas.transaccion (fecha_hora, total, metodo_pago) VALUES (?, ?, ?)";
            ps = conexion.prepareStatement(query);
            ps.setTimestamp(1, Timestamp.valueOf(transaccion.getFechaHora()));
            ps.setBigDecimal(2, transaccion.getTotal());
            ps.setString(3, transaccion.getMetodoPago());
            
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
    }
    
    public void actualizarTransaccion(Transaccion transaccion) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        PreparedStatement ps = null;
        
        try {
            conexion = conn.getConexion();
            String query = "UPDATE tablas.transaccion SET fecha_hora = ?, total = ?, metodo_pago = ? WHERE id_transaccion = ?";
            ps = conexion.prepareStatement(query);
            ps.setTimestamp(1, Timestamp.valueOf(transaccion.getFechaHora()));
            ps.setBigDecimal(2, transaccion.getTotal());
            ps.setString(3, transaccion.getMetodoPago());
            ps.setInt(4, transaccion.getIdTransaccion());
            
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
    }
    
    public void eliminarTransaccion(int idTransaccion) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        PreparedStatement ps = null;
        
        try {
            conexion = conn.getConexion();
            String query = "DELETE FROM tablas.transaccion WHERE id_transaccion = ?";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, idTransaccion);
            
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
    }
    
    // Método para obtener transacciones por rango de fechas
    public List<Transaccion> getTransaccionesPorFecha(LocalDateTime fechaInicio, LocalDateTime fechaFin) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        List<Transaccion> transacciones = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conexion = conn.getConexion();
            String query = "SELECT * FROM tablas.transaccion WHERE fecha_hora BETWEEN ? AND ? ORDER BY fecha_hora ASC";
            ps = conexion.prepareStatement(query);
            ps.setTimestamp(1, Timestamp.valueOf(fechaInicio));
            ps.setTimestamp(2, Timestamp.valueOf(fechaFin));
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Transaccion transaccion = new Transaccion(
                    rs.getInt("id_transaccion"),
                    rs.getTimestamp("fecha_hora").toLocalDateTime(),
                    rs.getBigDecimal("total"),
                    rs.getString("metodo_pago")
                );
                transacciones.add(transaccion);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
        return transacciones;
    }
    
    // Método para obtener transacciones por método de pago
    public List<Transaccion> getTransaccionesPorMetodoPago(String metodoPago) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        List<Transaccion> transacciones = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conexion = conn.getConexion();
            String query = "SELECT * FROM tablas.transaccion WHERE metodo_pago = ? ORDER BY fecha_hora DESC";
            ps = conexion.prepareStatement(query);
            ps.setString(1, metodoPago);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Transaccion transaccion = new Transaccion(
                    rs.getInt("id_transaccion"),
                    rs.getTimestamp("fecha_hora").toLocalDateTime(),
                    rs.getBigDecimal("total"),
                    rs.getString("metodo_pago")
                );
                transacciones.add(transaccion);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
        return transacciones;
    }
    
    // Método para obtener el total de ventas por período
    public BigDecimal getTotalVentasPorPeriodo(LocalDateTime fechaInicio, LocalDateTime fechaFin) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        BigDecimal totalVentas = BigDecimal.ZERO;
        
        try {
            conexion = conn.getConexion();
            String query = "SELECT SUM(total) FROM tablas.transaccion WHERE fecha_hora BETWEEN ? AND ?";
            ps = conexion.prepareStatement(query);
            ps.setTimestamp(1, Timestamp.valueOf(fechaInicio));
            ps.setTimestamp(2, Timestamp.valueOf(fechaFin));
            rs = ps.executeQuery();
            
            if (rs.next()) {
                totalVentas = rs.getBigDecimal(1);
                if (totalVentas == null) {
                    totalVentas = BigDecimal.ZERO;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
        return totalVentas;
    }
}