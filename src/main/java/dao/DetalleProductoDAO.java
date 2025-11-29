package dao;

import conexion.Conexion;
import entity.DetalleProducto;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DetalleProductoDAO {
    
    public List<DetalleProducto> getDetallesProducto() {
        Conexion conn = new Conexion();
        Connection conexion = null;
        List<DetalleProducto> detalles = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conexion = conn.getConexion();
            String query = "SELECT * FROM tablas.detalle_producto ORDER BY id_detalle ASC";
            ps = conexion.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                DetalleProducto detalle = new DetalleProducto(
                    rs.getInt("id_detalle"),
                    rs.getInt("id_transaccion"),
                    rs.getInt("id_producto"),
                    rs.getInt("cantidad"),
                    rs.getBigDecimal("subtotal")
                );
                detalles.add(detalle);
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
        return detalles;
    }
    
    public List<DetalleProducto> getDetallesPorTransaccion(int idTransaccion) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        List<DetalleProducto> detalles = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conexion = conn.getConexion();
            String query = "SELECT * FROM tablas.detalle_producto WHERE id_transaccion = ? ORDER BY id_detalle ASC";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, idTransaccion);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                DetalleProducto detalle = new DetalleProducto(
                    rs.getInt("id_detalle"),
                    rs.getInt("id_transaccion"),
                    rs.getInt("id_producto"),
                    rs.getInt("cantidad"),
                    rs.getBigDecimal("subtotal")
                );
                detalles.add(detalle);
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
        return detalles;
    }
    
    public DetalleProducto getDetallePorId(int idDetalle) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        DetalleProducto detalle = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conexion = conn.getConexion();
            String query = "SELECT * FROM tablas.detalle_producto WHERE id_detalle = ?";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, idDetalle);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                detalle = new DetalleProducto(
                    rs.getInt("id_detalle"),
                    rs.getInt("id_transaccion"),
                    rs.getInt("id_producto"),
                    rs.getInt("cantidad"),
                    rs.getBigDecimal("subtotal")
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
        return detalle;
    }
    
    public void insertarDetalleProducto(DetalleProducto detalle) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        PreparedStatement ps = null;
        
        try {
            conexion = conn.getConexion();
            String query = "INSERT INTO tablas.detalle_producto (id_transaccion, id_producto, cantidad, subtotal) VALUES (?, ?, ?, ?)";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, detalle.getIdTransaccion());
            ps.setInt(2, detalle.getIdProducto());
            ps.setInt(3, detalle.getCantidad());
            ps.setBigDecimal(4, detalle.getSubtotal());
            
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
    
    public void actualizarDetalleProducto(DetalleProducto detalle) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        PreparedStatement ps = null;
        
        try {
            conexion = conn.getConexion();
            String query = "UPDATE tablas.detalle_producto SET id_transaccion = ?, id_producto = ?, cantidad = ?, subtotal = ? WHERE id_detalle = ?";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, detalle.getIdTransaccion());
            ps.setInt(2, detalle.getIdProducto());
            ps.setInt(3, detalle.getCantidad());
            ps.setBigDecimal(4, detalle.getSubtotal());
            ps.setInt(5, detalle.getIdDetalle());
            
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
    
    public void eliminarDetalleProducto(int idDetalle) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        PreparedStatement ps = null;
        
        try {
            conexion = conn.getConexion();
            String query = "DELETE FROM tablas.detalle_producto WHERE id_detalle = ?";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, idDetalle);
            
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
    
    // Método para eliminar todos los detalles de una transacción
    public void eliminarDetallesPorTransaccion(int idTransaccion) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        PreparedStatement ps = null;
        
        try {
            conexion = conn.getConexion();
            String query = "DELETE FROM tablas.detalle_producto WHERE id_transaccion = ?";
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
    
    // Método para calcular el total de una transacción
    public BigDecimal getTotalPorTransaccion(int idTransaccion) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        BigDecimal total = BigDecimal.ZERO;
        
        try {
            conexion = conn.getConexion();
            String query = "SELECT SUM(subtotal) FROM tablas.detalle_producto WHERE id_transaccion = ?";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, idTransaccion);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                total = rs.getBigDecimal(1);
                if (total == null) {
                    total = BigDecimal.ZERO;
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
        return total;
    }
}